require 'tempfile'

FactoryBot.define do
  factory :file_message, class: Threema::Send::File do
    threema    { FactoryBot.build(:threema) }
    threema_id { test_threema_id }
    file       { hello_world.b }

    initialize_with do
      new(attributes)
    end
  end
end
