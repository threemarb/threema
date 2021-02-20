# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::Send::E2EBase do
  it 'raises a RuntimeError if no public key could be found' do
    attributes = attributes_for(:text_message)

    mock_error(404)

    expect { described_class.new(attributes) }.to raise_error(RuntimeError)
  end

  it 'raises a RuntimeError if receipient is not capable of receiving the tried message type' do
    # build dummy class since the base class never calls this method - TODO: but maybe should?!
    class Threema
      class Send
        class Example < Threema::Send::E2EBase
          def initialize(params)
            super
            check_capability(:text)
          end
        end
      end
    end

    attributes = attributes_for(:image_message)

    mock_pubkey(attributes[:threema_id], test_public_key)

    mock_capabilities(attributes[:threema_id], 'nothing :)')

    expect { Threema::Send::Example.new(attributes) }.to raise_error(RuntimeError)
  end
end
