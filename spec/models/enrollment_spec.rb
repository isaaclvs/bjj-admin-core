require "rails_helper"

RSpec.describe Enrollment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:student) }
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to have_many(:payments).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:started_at) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(active: 0, cancelled: 1, suspended: 2) }
  end

  describe "after_create :generate_first_payment" do
    it "creates a first payment on enrollment creation" do
      academy    = create(:academy)
      plan       = create(:plan, academy: academy, price_cents: 12000)
      student    = create(:student, academy: academy)
      enrollment = create(:enrollment, student: student, plan: plan, started_at: Date.today)

      expect(enrollment.payments.count).to eq(1)
    end

    it "creates the payment with the plan's price" do
      academy    = create(:academy)
      plan       = create(:plan, academy: academy, price_cents: 12000)
      student    = create(:student, academy: academy)
      enrollment = create(:enrollment, student: student, plan: plan, started_at: Date.today)

      expect(enrollment.payments.first.amount_cents).to eq(12000)
    end

    it "creates the payment with due_date equal to started_at" do
      academy    = create(:academy)
      plan       = create(:plan, academy: academy)
      student    = create(:student, academy: academy)
      started    = Date.today
      enrollment = create(:enrollment, student: student, plan: plan, started_at: started)

      expect(enrollment.payments.first.due_date).to eq(started)
    end
  end
end
