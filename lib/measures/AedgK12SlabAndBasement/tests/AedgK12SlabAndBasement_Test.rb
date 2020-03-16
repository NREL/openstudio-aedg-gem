# *******************************************************************************
# OpenStudio(R), Copyright (c) 2008-2020, Alliance for Sustainable Energy, LLC.
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
class AedgK12SlabAndBasement_Test < Minitest::Test
  def test_AedgK12SlabAndBasement_withBasementModel
    #skip "Broken in 2.5.1, address immediately"
    # create an instance of the measure
    measure = AedgK12SlabAndBasement.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)
    runner.setLastEpwFilePath(OpenStudio::Path.new("#{File.dirname(__FILE__)}/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"))

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/CorePerim_Basement.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # set last model
    runner.setLastOpenStudioModel(model)

    # forward translate OpenStudio Model to EnergyPlus Workspace
    ft = OpenStudio::EnergyPlus::ForwardTranslator.new
    workspace = ft.translateModel(model)

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(workspace)
    # assert_equal(0, arguments.size)

    # set argument values to good values and run the measure on the workspace
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    count = -1

    target = arguments[count += 1].clone
    assert(target.setValue('ASHRAE 90.1 2004'))
    argument_map['target'] = target

    slabOrBasement = arguments[count += 1].clone
    assert(slabOrBasement.setValue('Basement (choose this if you have below grade walls)'))
    argument_map['slabOrBasement'] = slabOrBasement

    heatedSlab = arguments[count += 1].clone
    assert(heatedSlab.setValue(false))
    argument_map['heatedSlab'] = heatedSlab

    apRatio = arguments[count += 1].clone
    assert(apRatio.setValue(32.5))
    argument_map['apRatio'] = apRatio

    costTotalSlabBasementInsulation = arguments[count += 1].clone
    assert(costTotalSlabBasementInsulation.setValue(0.0))
    argument_map['costTotalSlabBasementInsulation'] = costTotalSlabBasementInsulation

    measure.run(workspace, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 0)
    # assert(result.info.size == 0)

    # save the model in an output directory
    output_dir = File.expand_path('output', File.dirname(__FILE__))
    FileUtils.mkdir output_dir unless Dir.exist? output_dir
    workspace.save("#{output_dir}/test.idf", true)
  end

  def test_AedgK12SlabAndBasement_withSlabModel
    #skip "Broken in 2.5.1, address immediately"
    
    # create an instance of the measure
    measure = AedgK12SlabAndBasement.new

    # create an instance of a runner
    runner = OpenStudio::Measure::OSRunner.new(OpenStudio::WorkflowJSON.new)
    runner.setLastEpwFilePath(OpenStudio::Path.new("#{File.dirname(__FILE__)}/USA_CO_Golden-NREL.724666_TMY3.epw"))

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = OpenStudio::Path.new(File.dirname(__FILE__) + '/CorePerim_NoBasement.osm')
    model = translator.loadModel(path)
    assert(!model.empty?)
    model = model.get

    # set last model
    runner.setLastOpenStudioModel(model)

    # forward translate OpenStudio Model to EnergyPlus Workspace
    ft = OpenStudio::EnergyPlus::ForwardTranslator.new
    workspace = ft.translateModel(model)

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(workspace)
    # assert_equal(0, arguments.size)

    # set argument values to good values and run the measure on the workspace
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    count = -1

    target = arguments[count += 1].clone
    assert(target.setValue('AEDG K-12 - Target'))
    argument_map['target'] = target

    slabOrBasement = arguments[count += 1].clone
    assert(slabOrBasement.setValue('Slab'))
    argument_map['slabOrBasement'] = slabOrBasement

    heatedSlab = arguments[count += 1].clone
    assert(heatedSlab.setValue(true))
    argument_map['heatedSlab'] = heatedSlab

    apRatio = arguments[count += 1].clone
    assert(apRatio.setValue(32.5))
    argument_map['apRatio'] = apRatio

    costTotalSlabBasementInsulation = arguments[count += 1].clone
    assert(costTotalSlabBasementInsulation.setValue(0.0))
    argument_map['costTotalSlabBasementInsulation'] = costTotalSlabBasementInsulation

    measure.run(workspace, runner, argument_map)
    result = runner.result
    show_output(result)
    assert(result.value.valueName == 'Success')
    # assert(result.warnings.size == 0)
    # assert(result.info.size == 0)

    # save the model in an output directory
    output_dir = File.expand_path('output', File.dirname(__FILE__))
    FileUtils.mkdir output_dir unless Dir.exist? output_dir
    workspace.save("#{output_dir}/test_2.idf", true)
  end
end
