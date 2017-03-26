require 'spec_helper'

RSpec.describe Threema::Send::Simple do
  context '#payload' do
    it 'responds to payload' do
      instance = build(:simple_message_threema_id)
      expect(instance).to respond_to(:payload)
    end

    context 'required payload keys' do
      it 'can take Threema ID' do
        instance = build(:simple_message_threema_id)
        payload = instance.payload

        expect(payload).to be_a(Hash)
        expect(payload).to have_key(:to)
        expect(payload).to have_key(:text)
      end

      it 'can take phone' do
        instance = build(:simple_message_phone)
        payload = instance.payload

        expect(payload).to be_a(Hash)
        expect(payload).to have_key(:phone)
        expect(payload).to have_key(:text)
      end

      it 'can take email' do
        instance = build(:simple_message_email)
        payload = instance.payload

        expect(payload).to be_a(Hash)
        expect(payload).to have_key(:email)
        expect(payload).to have_key(:text)
      end

      context 'required parameters' do
        it 'requires one receipient key' do
          attributes = attributes_for(:simple_message_threema_id)
          attributes.delete(:threema_id)
          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end

        it 'requires text' do
          attributes = attributes_for(:simple_message_threema_id)
          attributes.delete(:text)
          expect { described_class.new(attributes) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
