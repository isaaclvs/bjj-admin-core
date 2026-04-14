FactoryBot.define do
  factory :health_record do
    association :student
    blood_type     { %w[A+ A- B+ B- AB+ AB- O+ O-].sample }
    uses_medication { false }
    lgpd_consent   { true }
    lgpd_consent_at { Time.current }
    comorbidities  { [] }
    allergies      { [] }
    injuries       { [] }
    risk_flag      { false }

    trait :with_risk do
      comorbidities { [ "hipertensão" ] }
      risk_flag     { true }
    end
  end
end
