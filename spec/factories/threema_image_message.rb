require 'tempfile'

FactoryGirl.define do
  factory :image_message, class: Threema::Send::Image do
    threema    { FactoryGirl.build(:threema) }
    threema_id test_threema_id
    image      'imagecontent'.b

    initialize_with do
      new(attributes)
    end
  end
end
