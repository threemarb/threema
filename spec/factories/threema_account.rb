FactoryBot.define do
  factory :threema_account, class: Threema::Account do
    threema { FactoryBot.build(:threema) }

    initialize_with do
      new(attributes)
    end
  end
end
