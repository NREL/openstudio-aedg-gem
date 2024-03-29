# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgK12FenestrationAndDaylightingControls_Test < Minitest::Test
  def test_AedgK12FenestrationAndDaylightingControls
    # create an instance of the measure
    measure = AedgK12FenestrationAndDaylightingControls.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/SecondarySchoolCustomRef_01_0228.osm')
    # path = OpenStudio::Path.new(File.dirname(__FILE__) + "/DoorTest.osm")
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(5, arguments.size)
    assert_equal('cost_daylight_glazing', arguments[0].name)
    assert_equal('cost_view_glazing', arguments[1].name)
    assert_equal('cost_skylight', arguments[2].name)
    assert_equal('cost_shading_surface', arguments[3].name)
    assert_equal('cost_light_shelf', arguments[4].name)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    cost_daylight_glazing = arguments[0].clone
    assert(cost_daylight_glazing.setValue(0.0))
    argument_map['cost_daylight_glazing'] = cost_daylight_glazing

    cost_view_glazing = arguments[1].clone
    assert(cost_view_glazing.setValue(0.0))
    argument_map['cost_view_glazing'] = cost_view_glazing

    cost_skylight = arguments[2].clone
    assert(cost_skylight.setValue(0.0))
    argument_map['cost_skylight'] = cost_skylight

    cost_shading_surface = arguments[3].clone
    assert(cost_shading_surface.setValue(0.0))
    argument_map['cost_shading_surface'] = cost_shading_surface

    cost_light_shelf = arguments[4].clone
    assert(cost_light_shelf.setValue(0.0))
    argument_map['cost_light_shelf'] = cost_light_shelf

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)

    # save the model in an output directory
    output_dir = File.expand_path('output', File.dirname(__FILE__))
    FileUtils.mkdir output_dir unless Dir.exist? output_dir
    model.save("#{output_dir}/test.osm", true)
  end
end
