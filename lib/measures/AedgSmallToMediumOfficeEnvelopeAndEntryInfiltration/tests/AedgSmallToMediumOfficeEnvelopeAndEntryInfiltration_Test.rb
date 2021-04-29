# *******************************************************************************
# OpenStudio(R), Copyright (c) 2008-2021, Alliance for Sustainable Energy, LLC.
# All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# (1) Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# (2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# (3) Neither the name of the copyright holder nor the names of any contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission from the respective party.
#
# (4) Other than as required in clauses (1) and (2), distributions in any form
# of modifications or other derivative works may not use the "OpenStudio"
# trademark, "OS", "os", or any other confusingly similar designation without
# specific prior written permission from Alliance for Sustainable Energy, LLC.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER(S) AND ANY CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER(S), ANY CONTRIBUTORS, THE
# UNITED STATES GOVERNMENT, OR THE UNITED STATES DEPARTMENT OF ENERGY, NOR ANY OF
# THEIR EMPLOYEES, BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
# OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# *******************************************************************************

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'fileutils'

require_relative '../measure.rb'
require 'minitest/autorun'

class AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration_Test < Minitest::Test
  def test_AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration.new

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
    assert(infiltrationEnvelope.setValue('AEDG Small To Medium Office - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by Small to Medium Office AEDG'))
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

  def test_AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration_SingleDoor
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration.new

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
    assert(infiltrationEnvelope.setValue('AEDG Small To Medium Office - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by Small to Medium Office AEDG'))
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
  end

  def test_AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration_BoxProfileTest
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration.new

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
    assert(infiltrationEnvelope.setValue('AEDG Small To Medium Office - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by Small to Medium Office AEDG'))
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
    model.save("#{output_dir}/BoxProfileTest_output.osm", true)
  end

  def test_AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration_CurveProfileTest
    # create an instance of the measure
    measure = AedgSmallToMediumOfficeEnvelopeAndEntryInfiltration.new

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
    assert(infiltrationEnvelope.setValue('AEDG Small To Medium Office - Target'))
    argument_map['infiltrationEnvelope'] = infiltrationEnvelope

    infiltrationOccupant = arguments[1].clone
    assert(infiltrationOccupant.setValue('Model Occupant Entry With a Vestibule if Recommended by Small to Medium Office AEDG'))
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
    model.save("#{output_dir}/CurveProfileTest_output.osm", true)
  end
end
