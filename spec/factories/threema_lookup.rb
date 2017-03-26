FactoryGirl.define do
  factory :threema_lookup, class: Threema::Lookup do
    threema { FactoryGirl.build(:threema) }

    initialize_with do
      new(attributes)
    end
  end
end
