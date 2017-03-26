require 'spec_helper'

RSpec.describe Threema::Util do
  let(:string) { 'threema' }
  let(:hex) { '74687265656d61' }

  context '.hexify' do
    it 'responds to hexify' do
      expect(described_class).to respond_to(:hexify)
    end

    it 'hexifies strings' do
      expect(described_class.hexify(string)).to eq(hex)
    end
  end

  context '.unhexify' do
    it 'responds to unhexify' do
      expect(described_class).to respond_to(:unhexify)
    end

    it 'unhexifies strings' do
      expect(described_class.unhexify(hex)).to eq(string)
    end
  end
end
