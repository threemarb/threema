FactoryGirl.define do
  factory :threema do
    api_identity test_from
    api_secret   test_api_secret

    initialize_with do
      new(attributes)
    end
  end
end
