# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

# see the URL below for information on how to write OpenStudio measures
# http://openstudio.nrel.gov/openstudio-measure-writing-guide

# see the URL below for information on using life cycle cost objects in OpenStudio
# http://openstudio.nrel.gov/openstudio-life-cycle-examples

# see the URL below for access to C++ documentation on model objects (click on "model" in the main window to view model objects)
# http://openstudio.nrel.gov/sites/openstudio.nrel.gov/files/nv_data/cpp_documentation_it/model/html/namespaces.html

# load OpenStudio measure libraries from openstudio-extension gem
require 'openstudio-extension'
require 'openstudio/extension/core/os_lib_helper_methods'
require 'openstudio/extension/core/os_lib_lighting_and_equipment'
require 'openstudio/extension/core/os_lib_schedules'

# load OpenStudio measure libraries
require "#{File.dirname(__FILE__)}/resources/OsLib_AedgMeasures"

# start the measure
class AedgSmallToMediumOfficeInteriorLightingControls < OpenStudio::Measure::ModelMeasure
  # define the name that a user will see, this method may be deprecated as
  # the display name in PAT comes from the name field in measure.xml
  def name
    return 'AedgSmallToMediumOfficeInteriorLightingControls'
  end

  # define the arguments that the user will input
  def arguments(model)
    args = OpenStudio::Measure::OSArgumentVector.new

    # make an argument for material and installation cost
    costTotal = OpenStudio::Measure::OSArgument.makeDoubleArgument('costTotal', true)
    costTotal.setDisplayName('Total cost for all Lighting Controls in the Building ($).')
    costTotal.setDefaultValue(0.0)
    args << costTotal

    return args
  end

  # define what happens when the measure is run
  def run(model, runner, user_arguments)
    super(model, runner, user_arguments)

    # use the built-in error checking
    if !runner.validateUserArguments(arguments(model), user_arguments)
      return false
    end

    # assign the user inputs to variables
    costTotal = runner.getDoubleArgumentValue('costTotal', user_arguments)

    non_neg_args = ['costTotal']
    non_neg = OsLib_HelperMethods.checkDoubleAndIntegerArguments(runner, user_arguments, 'min' => 0.0, 'max' => nil, 'min_eq_bool' => true, 'max_eq_bool' => false, 'arg_array' => non_neg_args)
    if !non_neg then return false end

    # create not applicable flag if building doesn't have any lights.
    if model.getBuilding.lightingPower == 0
      runner.registerAsNotApplicable('The model does not appear to have interior lighting, the model will not be altered.')
      return true
    end

    # prepare rule hash
    rules = [] # target, space type, LPD_ip

    # currently only target is lower energy, but setup hash this way so could add baseline in future
    # climate zone doesn't impact values for LPD in AEDG

    # populate rules hash (schedule fractional multiplier for lighting controls)
    rules << ['ClosedOffice', 0.85]
    rules << ['Conference', 0.85]
    rules << ['IT_Room', 0.85]
    rules << ['Elec/MechRoom', 0.85]
    rules << ['OpenOffice', 0.95] # isn't clear what value this should be, but less reduction than typical
    rules << ['PrintRoom', 0.85]
    rules << ['Restroom', 0.85]
    rules << ['Storage', 0.85]
    rules << ['Vending', 0.85]
    rules << ['WholeBuilding - Sm Office', 0.85]
    rules << ['WholeBuilding - Md Office', 0.85]
    rules << ['WholeBuilding - Lg Office', 0.85]

    # make rule hash for cleaner code
    rulesHash = {}
    rules.each do |rule|
      rulesHash[(rule[0]).to_s] = rule[1]
    end

    # TODO: - add in a warning about luminaires or have this handle them as well.

    # get the initial range of light schedule values in the building for initial condition
    lightsHash = {} # key = existSch, value = newSch
    affectedSpaceTypeArray = []

    existMin = []
    existMax = []
    newMin = []
    newMax = []

    # make array of space and space types to loop through
    spacesAndSpaceTypes = []
    model.getSpaceTypes.each do |spaceType|
      next if spaceType.spaces.empty?
      standardsInfo = OsLib_HelperMethods.getSpaceTypeStandardsInformation([spaceType])
      next if rulesHash[(standardsInfo[spaceType][1]).to_s].nil?
      spacesAndSpaceTypes << spaceType
      affectedSpaceTypeArray << spaceType
    end
    model.getSpaces.each do |space|
      next if space.spaceType.empty?
      spaceType = space.spaceType.get
      standardsInfo = OsLib_HelperMethods.getSpaceTypeStandardsInformation([spaceType])
      next if rulesHash[(standardsInfo[spaceType][1]).to_s].nil?
      spacesAndSpaceTypes << space
    end

    if spacesAndSpaceTypes.empty?
      runner.registerAsNotApplicable('None of the space types in the model are candidates for office lighting controls.')
      return true
    end

    # loop through used space types and spaces
    spacesAndSpaceTypes.each do |object|
      # only alter space types that are used
      if !object.to_SpaceType.empty?
        next if object.to_SpaceType.get.spaces.size <= 0
      end

      # get standards
      if object.to_SpaceType.empty?
        if !object.spaceType.empty?
          spaceType = object.spaceType.get
          standardsInfo = OsLib_HelperMethods.getSpaceTypeStandardsInformation([spaceType])
        end
      else
        standardsInfo = OsLib_HelperMethods.getSpaceTypeStandardsInformation([object])
      end

      lights = object.lights
      lights.each do |light|
        # get schedule
        if !light.schedule.empty?
          existSch = light.schedule.get

          # can't process if not ruleset
          if existSch.to_ScheduleRuleset.empty?
            runner.registerWarning("#{existSch.name} isn't a ruleset schedule. It can't be altered by this measure.")
            next
          end

          # update schedule
          if lightsHash.key?(existSch)
            # connect light to new schedule
            light.setSchedule(lightsHash[existSch])
          else

            # make new schedule
            newSchedule = existSch.clone(model).to_ScheduleRuleset.get
            newSchedule.setName("#{existSch.name} - Controls Reduction")

            # connect to lights
            light.setSchedule(newSchedule)

            # edit schedule. Pass in fractional value from rules
            standardsInfo = OsLib_HelperMethods.getSpaceTypeStandardsInformation([object])
            OsLib_Schedules.simpleScheduleValueAdjust(model, newSchedule, rulesHash[(standardsInfo[object][1]).to_s], modificationType = 'Percentage')

            # add info to hash
            lightsHash[existSch] = newSchedule

            # get sch values from new and old schedules to use in initial and final condition
            existMinMax = OsLib_Schedules.getMinMaxAnnualProfileValue(model, existSch.to_ScheduleRuleset.get)
            existMin <<  existMinMax['min']
            existMax <<  existMinMax['max']
            newMinMax = OsLib_Schedules.getMinMaxAnnualProfileValue(model, newSchedule)
            newMin <<  newMinMax['min']
            newMax <<  newMinMax['max']
          end

        else
          runner.registerWarning("Can't find schedule for #{light.name} in #{object.name}. Won't attempt to create schedule for it.")
        end
      end
    end

    affectedSpaceTypeArray.each do |spaceType|
      runner.registerInfo("Adjusting lighting schedules for #{spaceType.name}.")
    end

    if existMin.empty? || existMax.empty?
      runner.registerAsNotApplicable('Lighting controls were not added to any applicable spaces or space types because they had no lighting.')
      return true
    end

    # reporting initial condition of model
    runner.registerInitialCondition("Fractional schedule values for lights in the initial model range from #{OpenStudio.toNeatString(existMin.min, 2, true)} to #{OpenStudio.toNeatString(existMax.max, 2, true)}.")

    # get building to add cost to
    building = model.getBuilding

    # global variables for costs
    expected_life = 25
    years_until_costs_start = 0

    # add cost to building
    if costTotal > 0
      lcc_mat = OpenStudio::Model::LifeCycleCost.createLifeCycleCost('Interior Lighting Controls', building, costTotal, 'CostPerEach', 'Construction', expected_life, years_until_costs_start)
      lcc_mat_TotalCost = lcc_mat.get.totalCost
    else
      lcc_mat_TotalCost = 0
    end

    # populate AEDG tip keys
    aedgTips = ['DL13', 'EL01', 'EL05', 'EL09', 'EL10']

    # populate how to tip messages
    aedgTipsLong = OsLib_AedgMeasures.getLongHowToTips('SmMdOff', aedgTips.uniq.sort, runner)
    if !aedgTipsLong
      return false # this should only happen if measure writer passes bad values to getLongHowToTips
    end

    # reporting final condition of model
    if lcc_mat_TotalCost > 0
      runner.registerFinalCondition("Fractional schedule values for lights in the final model range from #{OpenStudio.toNeatString(newMin.min, 2, true)} to #{OpenStudio.toNeatString(newMax.max, 2, true)}. The cost for these control improvements is $#{OpenStudio.toNeatString(lcc_mat_TotalCost, 2, true)}. #{aedgTipsLong}")
    else
      runner.registerFinalCondition("Fractional schedule values for lights in the final model range from #{OpenStudio.toNeatString(newMin.min, 2, true)} to #{OpenStudio.toNeatString(newMax.max, 2, true)}. #{aedgTipsLong}")
    end

    return true
  end
end

# this allows the measure to be use by the application
AedgSmallToMediumOfficeInteriorLightingControls.new.registerWithApplication
