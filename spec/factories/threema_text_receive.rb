# frozen_string_literal: true

FactoryBot.define do
  factory :text_receive, class: Threema::Receive::Text do
    content { hello_world }

    initialize_with do
      new(attributes)
    end
  end
end
