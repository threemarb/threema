FactoryGirl.define do
  factory :simple_message_threema_id, class: Threema::Send::Simple do
    threema_id test_threema_id
    text       hello_world

    initialize_with do
      new(attributes)
    end
  end

  factory :simple_message_phone, class: Threema::Send::Simple do
    phone '41791234567'
    text  hello_world

    initialize_with do
      new(attributes)
    end
  end

  factory :simple_message_email, class: Threema::Send::Simple do
    email 'test@threema.ch'
    text  hello_world

    initialize_with do
      new(attributes)
    end
  end
end
