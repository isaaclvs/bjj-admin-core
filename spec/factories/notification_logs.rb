FactoryBot.define do
  factory :notification_log do
    association :student
    notification_type { "payment_reminder" }
    channel           { "email" }
    sent_at           { Time.current }
  end
end
