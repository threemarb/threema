FactoryGirl.define do
  factory :typed_message_typed, class: Threema::TypedMessage do
    typed "\x01Hello World"

    initialize_with do
      new(attributes)
    end
  end

  factory :typed_message_text, class: Threema::TypedMessage do
    type    :text
    message hello_world

    initialize_with do
      new(attributes)
    end
  end
end
