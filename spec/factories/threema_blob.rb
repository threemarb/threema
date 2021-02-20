# frozen_string_literal: true

FactoryBot.define do
  factory :threema_blob, class: Threema::Blob do
    threema { FactoryBot.build(:threema) }

    initialize_with do
      new(attributes)
    end
  end
end
