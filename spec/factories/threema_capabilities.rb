FactoryGirl.define do
  factory :threema_capabilities, class: Threema::Capabilities do
    threema { FactoryGirl.build(:threema) }

    initialize_with do
      new(attributes)
    end
  end
end
