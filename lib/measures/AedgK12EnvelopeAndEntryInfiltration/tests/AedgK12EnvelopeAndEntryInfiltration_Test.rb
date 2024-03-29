# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgK12EnvelopeAndEntryInfiltration_Test < Minitest::Test
  def test_AedgK12EnvelopeAndEntryInfiltration
    # create an instance of the measure
    measure = AedgK12EnvelopeAndEntryInfiltration.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0221_SimpleSchool_g_123_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(8, arguments.size)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    infiltrationEnvelope = arguments[0].clone
    assert(infiltrationEnvelope.setValue('AEDG K-12 - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by K12 AEDG'))
    argument_map['infiltrationOccupant'] = infiltrationOccupant

    story = arguments[2].clone
    assert(story.setValue('Building Story 1'))
    argument_map['story'] = story

    num_entries = arguments[3].clone
    assert(num_entries.setValue(4))
    argument_map['num_entries'] = num_entries

    doorOpeningEventsPerPerson = arguments[4].clone
    assert(doorOpeningEventsPerPerson.setValue(4.0))
    argument_map['doorOpeningEventsPerPerson'] = doorOpeningEventsPerPerson

    pressureDifferenceAcrossDoor_pa = arguments[5].clone
    assert(pressureDifferenceAcrossDoor_pa.setValue(4.0))
    argument_map['pressureDifferenceAcrossDoor_pa'] = pressureDifferenceAcrossDoor_pa

    costTotalEnvelopeInfiltration = arguments[6].clone
    assert(costTotalEnvelopeInfiltration.setValue(5000.0))
    argument_map['costTotalEnvelopeInfiltration'] = costTotalEnvelopeInfiltration

    costTotalEntryInfiltration = arguments[7].clone
    assert(costTotalEntryInfiltration.setValue(15000.0))
    argument_map['costTotalEntryInfiltration'] = costTotalEntryInfiltration

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

  def test_AedgK12EnvelopeAndEntryInfiltration_SingleDoor
    # create an instance of the measure
    measure = AedgK12EnvelopeAndEntryInfiltration.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0221_SimpleSchool_g_123_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(8, arguments.size)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    infiltrationEnvelope = arguments[0].clone
    assert(infiltrationEnvelope.setValue('AEDG K-12 - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by K12 AEDG'))
    argument_map['infiltrationOccupant'] = infiltrationOccupant

    story = arguments[2].clone
    assert(story.setValue('Building Story 1'))
    argument_map['story'] = story

    num_entries = arguments[3].clone
    assert(num_entries.setValue(1))
    argument_map['num_entries'] = num_entries

    doorOpeningEventsPerPerson = arguments[4].clone
    assert(doorOpeningEventsPerPerson.setValue(4.0))
    argument_map['doorOpeningEventsPerPerson'] = doorOpeningEventsPerPerson

    pressureDifferenceAcrossDoor_pa = arguments[5].clone
    assert(pressureDifferenceAcrossDoor_pa.setValue(4.0))
    argument_map['pressureDifferenceAcrossDoor_pa'] = pressureDifferenceAcrossDoor_pa

    costTotalEnvelopeInfiltration = arguments[6].clone
    assert(costTotalEnvelopeInfiltration.setValue(5000.0))
    argument_map['costTotalEnvelopeInfiltration'] = costTotalEnvelopeInfiltration

    costTotalEntryInfiltration = arguments[7].clone
    assert(costTotalEntryInfiltration.setValue(15000.0))
    argument_map['costTotalEntryInfiltration'] = costTotalEntryInfiltration

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)

    # save the model
    # output_file_path = OpenStudio::Path.new(File.dirname(__FILE__) + "/test.osm")
    # model.save(output_file_path,true)
  end

  def test_AedgK12EnvelopeAndEntryInfiltration_NoEntry_NoDoors
    # create an instance of the measure
    measure = AedgK12EnvelopeAndEntryInfiltration.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/0221_SimpleSchool_g_123_dev.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(8, arguments.size)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    infiltrationEnvelope = arguments[0].clone
    assert(infiltrationEnvelope.setValue('AEDG K-12 - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by K12 AEDG'))
    argument_map['infiltrationOccupant'] = infiltrationOccupant

    story = arguments[2].clone
    assert(story.setValue('Building Story 1'))
    argument_map['story'] = story

    num_entries = arguments[3].clone
    assert(num_entries.setValue(0))
    argument_map['num_entries'] = num_entries

    doorOpeningEventsPerPerson = arguments[4].clone
    assert(doorOpeningEventsPerPerson.setValue(0.0))
    argument_map['doorOpeningEventsPerPerson'] = doorOpeningEventsPerPerson

    pressureDifferenceAcrossDoor_pa = arguments[5].clone
    assert(pressureDifferenceAcrossDoor_pa.setValue(0.0))
    argument_map['pressureDifferenceAcrossDoor_pa'] = pressureDifferenceAcrossDoor_pa

    costTotalEnvelopeInfiltration = arguments[6].clone
    assert(costTotalEnvelopeInfiltration.setValue(0.0))
    argument_map['costTotalEnvelopeInfiltration'] = costTotalEnvelopeInfiltration

    costTotalEntryInfiltration = arguments[7].clone
    assert(costTotalEntryInfiltration.setValue(0.0))
    argument_map['costTotalEntryInfiltration'] = costTotalEntryInfiltration

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)

    # save the model
    # output_file_path = OpenStudio::Path.new(File.dirname(__FILE__) + "/test.osm")
    # model.save(output_file_path,true)
  end

  def test_AedgK12EnvelopeAndEntryInfiltration_BoxProfileTest
    # create an instance of the measure
    measure = AedgK12EnvelopeAndEntryInfiltration.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/BoxProfileTest.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(8, arguments.size)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    infiltrationEnvelope = arguments[0].clone
    assert(infiltrationEnvelope.setValue('AEDG K-12 - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by K12 AEDG'))
    argument_map['infiltrationOccupant'] = infiltrationOccupant

    story = arguments[2].clone
    assert(story.setValue('Building Story 1'))
    argument_map['story'] = story

    num_entries = arguments[3].clone
    assert(num_entries.setValue(4))
    argument_map['num_entries'] = num_entries

    doorOpeningEventsPerPerson = arguments[4].clone
    assert(doorOpeningEventsPerPerson.setValue(4.0))
    argument_map['doorOpeningEventsPerPerson'] = doorOpeningEventsPerPerson

    pressureDifferenceAcrossDoor_pa = arguments[5].clone
    assert(pressureDifferenceAcrossDoor_pa.setValue(4.0))
    argument_map['pressureDifferenceAcrossDoor_pa'] = pressureDifferenceAcrossDoor_pa

    costTotalEnvelopeInfiltration = arguments[6].clone
    assert(costTotalEnvelopeInfiltration.setValue(5000.0))
    argument_map['costTotalEnvelopeInfiltration'] = costTotalEnvelopeInfiltration

    costTotalEntryInfiltration = arguments[7].clone
    assert(costTotalEntryInfiltration.setValue(15000.0))
    argument_map['costTotalEntryInfiltration'] = costTotalEntryInfiltration

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)

    # save the model
    output_file_path = OpenStudio::Path.new(File.dirname(__FILE__) + '/output/BoxProfileTest_output.osm')
    model.save(output_file_path, true)
  end

  def test_AedgK12EnvelopeAndEntryInfiltration_CurveProfileTest
    # create an instance of the measure
    measure = AedgK12EnvelopeAndEntryInfiltration.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/CurveProfileTest.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(8, arguments.size)

    # set argument values to good values and run the measure on model with spaces
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)
    infiltrationEnvelope = arguments[0].clone
    assert(infiltrationEnvelope.setValue('AEDG K-12 - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by K12 AEDG'))
    argument_map['infiltrationOccupant'] = infiltrationOccupant

    story = arguments[2].clone
    assert(story.setValue('Building Story 1'))
    argument_map['story'] = story

    num_entries = arguments[3].clone
    assert(num_entries.setValue(4))
    argument_map['num_entries'] = num_entries

    doorOpeningEventsPerPerson = arguments[4].clone
    assert(doorOpeningEventsPerPerson.setValue(4.0))
    argument_map['doorOpeningEventsPerPerson'] = doorOpeningEventsPerPerson

    pressureDifferenceAcrossDoor_pa = arguments[5].clone
    assert(pressureDifferenceAcrossDoor_pa.setValue(4.0))
    argument_map['pressureDifferenceAcrossDoor_pa'] = pressureDifferenceAcrossDoor_pa

    costTotalEnvelopeInfiltration = arguments[6].clone
    assert(costTotalEnvelopeInfiltration.setValue(5000.0))
    argument_map['costTotalEnvelopeInfiltration'] = costTotalEnvelopeInfiltration

    costTotalEntryInfiltration = arguments[7].clone
    assert(costTotalEntryInfiltration.setValue(15000.0))
    argument_map['costTotalEntryInfiltration'] = costTotalEntryInfiltration

    measure.run(model, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 1)
    # assert(result.info.size == 2)

    # save the model
    output_file_path = OpenStudio::Path.new(File.dirname(__FILE__) + '/output/CurveProfileTest_output.osm')
    model.save(output_file_path, true)
  end
end
