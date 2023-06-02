# frozen_string_literal: true

# *******************************************************************************
# OpenStudio(R), Copyright (c) Alliance for Sustainable Energy, LLC.
# See also https://openstudio.net/license
# *******************************************************************************

require_relative '../spec_helper'

RSpec.describe OpenStudio::AedgMeasures do
  it 'has a version number' do
    expect(OpenStudio::AedgMeasures::VERSION).not_to be nil
  end

  it 'has a measures directory' do
    instance = OpenStudio::AedgMeasures::Extension.new
    expect(File.exist?(File.join(instance.measures_dir, 'AedgK12ElectricEquipment/'))).to be true
  end
end
