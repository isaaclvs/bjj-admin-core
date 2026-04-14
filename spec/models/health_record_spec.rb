require "rails_helper"

RSpec.describe HealthRecord, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:student) }
  end

  describe "RiskAssessable concern" do
    it "sets risk_flag when comorbidities contain a risk condition" do
      student = create(:student)
      record = create(:health_record,
                      student: student,
                      comorbidities: ["hipertensão"])
      expect(record.risk_flag).to be true
    end

    it "does not set risk_flag for benign conditions" do
      student = create(:student)
      record = create(:health_record,
                      student: student,
                      comorbidities: ["miopia"])
      expect(record.risk_flag).to be false
    end
  end

  describe "lgpd_consent_at callback" do
    it "sets lgpd_consent_at when consent is given" do
      student = create(:student)
      record  = create(:health_record, student: student, lgpd_consent: true)
      expect(record.lgpd_consent_at).not_to be_nil
    end
  end
end
