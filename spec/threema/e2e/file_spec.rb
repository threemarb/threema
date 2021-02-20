# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::E2e::File do
  it 'has NONCE constant' do
    expect(described_class).to have_constant(:NONCE)
    expect(described_class::NONCE).to be_a(Hash)
  end
end
