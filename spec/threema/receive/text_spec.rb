require 'spec_helper'

RSpec.describe Threema::Receive::Text do
  context '#content' do
    it 'responds to content' do
      instance = build(:text_receive)
      expect(instance).to respond_to(:content)
    end

    it 'returns text content' do
      attributes = attributes_for(:text_receive)
      instance = described_class.new(attributes)
      expect(instance.content).to eq(attributes[:content])
    end
  end
end
