# frozen_string_literal: true

FactoryBot.define do
  factory :text_message, class: Threema::Send::Text do
    threema    { FactoryBot.build(:threema) }
    threema_id { test_threema_id }
    text       { hello_world }
    public_key { nil }

    initialize_with do
      new(**attributes)
    end
  end
end
