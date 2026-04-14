require "rails_helper"

RSpec.describe Payment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:enrollment) }
    it { is_expected.to belong_to(:student) }
  end

  describe "validations" do
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than(0) }
    it { is_expected.to validate_presence_of(:due_date) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, paid: 1, overdue: 2, cancelled: 3) }
  end

  describe "#amount" do
    it "returns amount in BRL" do
      payment = build(:payment, amount_cents: 15000)
      expect(payment.amount).to eq(150.0)
    end
  end

  describe "before_save :mark_overdue_if_past_due" do
    it "marks payment as overdue when due_date is in the past" do
      enrollment = create(:enrollment)
      payment = enrollment.payments.first
      payment.update!(due_date: Date.today - 1, status: :pending)
      payment.save!
      expect(payment.reload.status).to eq("overdue")
    end
  end

  describe ".overdue scope" do
    it "includes explicitly overdue payments" do
      payment = create(:payment, :overdue)
      expect(Payment.overdue).to include(payment)
    end
  end
end
