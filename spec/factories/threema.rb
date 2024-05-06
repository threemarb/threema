# frozen_string_literal: true

FactoryBot.define do
  factory :threema do
    api_identity { test_from }
    api_secret   { test_api_secret }
    private_key { test_private_key }

    initialize_with do
      new(**attributes)
    end
  end
end
