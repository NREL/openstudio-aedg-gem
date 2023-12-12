# frozen_string_literal: true

# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgSmallToMediumOfficeInteriorFinishes_Test < Minitest::Test
  def test_AedgSmallToMediumOfficeInteriorFinishes_SingleConstruction
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeInteriorFinishes.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0213_SimpleSchool_f_124_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(2, arguments.size)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    construction = arguments[0].clone
    assert(construction.setValue('000 Interior Partition copy 1'))
    argument_map['object'] = construction
    lowerPartitions = arguments[1].clone
    assert(lowerPartitions.setValue(true))
    argument_map['lowerPartitions'] = lowerPartitions

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)
  end

  def test_AedgSmallToMediumOfficeInteriorFinishes_AllConstructions
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeInteriorFinishes.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0213_SimpleSchool_f_124_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    construction = arguments[0].clone
    assert(construction.setValue('*All Interior Partition Surfaces*'))
    argument_map['object'] = construction
    lowerPartitions = arguments[1].clone
    assert(lowerPartitions.setValue(true))
    argument_map['lowerPartitions'] = lowerPartitions

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)
  end

  def test_AedgSmallToMediumOfficeInteriorFinishes_AllConstructions_DoNotLower
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeInteriorFinishes.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0213_SimpleSchool_f_124_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    construction = arguments[0].clone
    assert(construction.setValue('*All Interior Partition Surfaces*'))
    argument_map['object'] = construction
    lowerPartitions = arguments[1].clone
    assert(lowerPartitions.setValue(false))
    argument_map['lowerPartitions'] = lowerPartitions

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)
  end
end
