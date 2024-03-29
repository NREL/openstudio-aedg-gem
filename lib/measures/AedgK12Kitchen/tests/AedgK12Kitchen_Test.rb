# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgK12Kitchen_Test < Minitest::Test
  def test_AedgK12Kitchen
    # create an instance of the measure
    measure = AedgK12Kitchen.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/AEDG_HVAC_GenericTestModel_0225_a.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    puts arguments
    assert_equal(2, arguments.size)
    assert_equal('costTotalKitchenSystem', arguments[0].name)
    assert_equal('numberOfStudents', arguments[1].name)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    costTotalKitchenSystem = arguments[0].clone
    assert(costTotalKitchenSystem.setValue(10000.0))
    argument_map['costTotalKitchenSystem'] = costTotalKitchenSystem

    numberOfStudents = arguments[1].clone
    assert(numberOfStudents.hasDefaultValue)
    assert(numberOfStudents.setValue(numberOfStudents.defaultValueAsInteger))
    # assert(numberOfStudents.setValue(123))
    argument_map['numberOfStudents'] = numberOfStudents

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)

    # save the model in an output directory
    # output_dir = File.expand_path('output', File.dirname(__FILE__))
    # FileUtils.mkdir output_dir unless Dir.exist? output_dir
    # puts "saving file to #{output_dir}"
    # model.save("#{output_dir}/test.osm", true)
  end
end
