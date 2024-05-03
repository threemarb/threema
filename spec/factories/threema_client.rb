# frozen_string_literal: true

FactoryBot.define do
  factory :threema_client, class: Threema::Client do
    threema

    initialize_with do
      new(**attributes)
    end
  end
end
