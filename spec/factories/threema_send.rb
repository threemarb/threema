# frozen_string_literal: true

FactoryBot.define do
  factory :threema_send, class: Threema::Send do
    threema { FactoryBot.build(:threema) }

    initialize_with do
      new(**attributes)
    end
  end
end
