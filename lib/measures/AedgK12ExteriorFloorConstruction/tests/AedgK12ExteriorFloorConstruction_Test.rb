# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgK12ExteriorFloorConstruction_Test < Minitest::Test
  def test_AedgK12ExteriorFloorConstruction
    # create an instance of the measure
    measure = AedgK12ExteriorFloorConstruction.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0210_SimpleSchool_d_123_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(1, arguments.size)
    assert_equal('material_cost_insulation_increase_ip', arguments[0].name)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    material_cost_insulation_increase_ip = arguments[0].clone
    assert(material_cost_insulation_increase_ip.setValue(5.0))
    argument_map['material_cost_insulation_increase_ip'] = material_cost_insulation_increase_ip
    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    # assert(result.value.valueName == "Success")
    # assert(result.warnings.size == 0)
    # assert(result.info.size == 0)
  end
end
