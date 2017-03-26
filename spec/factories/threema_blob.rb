FactoryGirl.define do
  factory :threema_blob, class: Threema::Blob do
    threema { FactoryGirl.build(:threema) }

    initialize_with do
      new(attributes)
    end
  end
end
