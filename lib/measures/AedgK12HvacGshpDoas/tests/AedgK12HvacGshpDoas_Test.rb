# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgK12HvacGshpDoas_Test < Minitest::Test
  def test_AedgK12HvacGshpDoas
    output_dir = OpenStudio::Path.new(File.dirname(__FILE__) + '/output')
    OpenStudio.removeDirectory(output_dir)
    Dir.mkdir(output_dir.to_s)

    osm_paths = Dir.glob(File.dirname(__FILE__) + '/*.osm')

    osm_paths.each do |string_path|
      path = OpenStudio::Path.new(string_path)

      # create an instance of the measure
      measure = AedgK12HvacGshpDoas.new

      # create an instance of a runner
      runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

      # load the test model
      translator = OpenStudio::OSVersion::VersionTranslator.new
      model = translator.loadModel(path)
      assert(!model.empty?)
      model = model.get

      # get arguments and test that they are what we are expecting
      arguments = measure.arguments(model)
      assert_equal(3, arguments.size)
      assert_equal('ceilingReturnPlenumSpaceType', arguments[0].name)
      assert_equal('costTotalHVACSystem', arguments[1].name)
      assert_equal('remake_schedules', arguments[2].name)

      # set argument values to good values and run the measure on model with spaces
      argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

      ceilingReturnPlenumSpaceType = arguments[0].clone
      assert(ceilingReturnPlenumSpaceType.setValue('Plenum'))
      argument_map['ceilingReturnPlenumSpaceType'] = ceilingReturnPlenumSpaceType

      costTotalHVACSystem = arguments[1].clone
      assert(costTotalHVACSystem.setValue(15000.0))
      argument_map['costTotalHVACSystem'] = costTotalHVACSystem

      remake_schedules = arguments[2].clone
      assert(remake_schedules.setValue(true))
      argument_map['remake_schedules'] = remake_schedules

      measure.run(model, runner, argument_map)
      result = runner.result
      show_output(result)
      assert(result.value.valueName == 'Success')

      # save the model for testing purposes
      # TODO: Convert this to using ruby paths, not OpenStudio
      output_model_dir = output_dir / OpenStudio::Path.new(path.stem)
      Dir.mkdir(output_model_dir.to_s)
      output_model_path = output_model_dir / OpenStudio::Path.new('test.osm')
      model.save(output_model_path, true)
    end
  end
end
