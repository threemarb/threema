# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema do
  let(:instance) { build(:threema) }

  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'provides access to the client' do
    expect(instance).to respond_to(:client)
    expect(instance.client).to be_a(Threema::Client)
  end

  context '#send' do
    it 'responds to send' do
      expect(instance).to respond_to(:send)
    end

    it "requires ':type' parameter" do
      attributes = attributes_for(:text_message)

      expect do
        instance.send(attributes)
      end
        .to raise_error(ArgumentError)
    end

    it 'tunnels send messages' do
      %i[text file].each do |message_type|
        attributes = attributes_for("#{message_type}_message".to_sym)

        expect_any_instance_of(Threema::Send).to receive(message_type).with(attributes)

        instance.send(attributes.merge(type: message_type))
      end
    end
  end

  context '#receive' do
    it 'responds to receive' do
      expect(instance).to respond_to(:receive)
    end

    it 'tunnels receive message' do
      payload = {}
      expect(Threema::Receive).to receive(:e2e)
      instance.receive(payload)
    end
  end
end
