FactoryBot.define do
  factory :payment do
    association :enrollment
    association :student
    amount_cents { 15000 }
    due_date     { Date.today + 30 }
    status       { :pending }
    add_attribute(:method) { :pix }

    trait :overdue do
      due_date { Date.today - 10 }
      status   { :overdue }
    end

    trait :paid do
      status  { :paid }
      paid_at { Date.today }
    end
  end
end
