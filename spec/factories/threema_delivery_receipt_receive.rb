# frozen_string_literal: true

FactoryBot.define do
  factory :delivery_receipt_receive, class: Threema::Receive::DeliveryReceipt do
    content { "\x01\xE0\xC8\x12n8]\xF3\x19".b }

    initialize_with do
      new(**attributes)
    end
  end
end
