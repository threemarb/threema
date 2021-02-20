# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Threema::TypedMessage do
  context 'class methods' do
    context '.type_by' do
      it 'responds to type_by' do
        expect(described_class).to respond_to(:type_by)
      end
    end

    context '.byte_by' do
      it 'responds to byte_by' do
        expect(described_class).to respond_to(:byte_by)
      end
    end
  end

  it 'creates from typed or type and message parameters' do
    from_typed = build(:typed_message_typed)
    from_text  = build(:typed_message_text)

    expect(from_typed.typed).to eq(from_text.typed)
    expect(from_typed.message).to eq(from_text.message)
    expect(from_typed.type).to eq(from_text.type)
  end

  context 'created from typed' do
    let(:typed_message) { build(:typed_message_typed) }

    context '#type' do
      it 'returns a Symbol' do
        expect(typed_message.type).to be_kind_of(Symbol)
      end
    end

    context '#message' do
      it 'returns a String' do
        expect(typed_message.message).to be_kind_of(String)
      end
    end

    context '#typed' do
      it 'returns a String' do
        expect(typed_message.typed).to be_kind_of(String)
      end
    end
  end

  context 'created from type and message' do
    let(:typed_message) { build(:typed_message_text) }

    context '#type' do
      it 'returns a Symbol' do
        expect(typed_message.type).to be_kind_of(Symbol)
      end
    end

    context '#message' do
      it 'returns a String' do
        expect(typed_message.message).to be_kind_of(String)
      end
    end

    context '#typed' do
      it 'returns a String' do
        expect(typed_message.typed).to be_kind_of(String)
      end
    end
  end
end
