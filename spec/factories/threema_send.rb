FactoryGirl.define do
  factory :threema_send, class: Threema::Send do
    threema { FactoryGirl.build(:threema) }

    initialize_with do
      new(attributes)
    end
  end
end
