require 'spec_helper'

RSpec.describe Threema::E2e::Image do
  it 'has FORMAT constant' do
    expect(described_class).to have_constant(:FORMAT)
  end
end
