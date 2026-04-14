require "rails_helper"

RSpec.describe OverduePaymentsQuery do
  let(:academy)       { create(:academy) }
  let(:other_academy) { create(:academy) }
  let(:student)       { create(:student, academy: academy) }
  let(:plan)          { create(:plan, academy: academy) }
  let(:enrollment)    { create(:enrollment, student: student, plan: plan) }

  subject(:result) { described_class.new(academy).call }

  describe "#call" do
    it "returns overdue payments for the given academy" do
      payment = enrollment.payments.first
      payment.update_columns(due_date: Date.today - 10, status: 2) # overdue

      expect(result).to include(payment)
    end

    it "excludes paid payments" do
      payment = enrollment.payments.first
      payment.update_columns(status: 1, paid_at: Date.today) # paid

      expect(result).not_to include(payment)
    end

    it "excludes pending payments with future due dates" do
      payment = enrollment.payments.first
      payment.update_columns(due_date: Date.today + 30, status: 0) # pending, future

      expect(result).not_to include(payment)
    end

    it "excludes overdue payments from other academies" do
      other_student    = create(:student, academy: other_academy)
      other_plan       = create(:plan, academy: other_academy)
      other_enrollment = create(:enrollment, student: other_student, plan: other_plan)
      other_payment    = other_enrollment.payments.first
      other_payment.update_columns(due_date: Date.today - 5, status: 2)

      expect(result).not_to include(other_payment)
    end

    it "orders results by due_date ascending" do
      payment = enrollment.payments.first
      payment.update_columns(due_date: Date.today - 5, status: 2)

      student2    = create(:student, academy: academy)
      enrollment2 = create(:enrollment, student: student2, plan: plan)
      payment2    = enrollment2.payments.first
      payment2.update_columns(due_date: Date.today - 15, status: 2)

      expect(result.first).to eq(payment2)
      expect(result.second).to eq(payment)
    end

    it "accepts a custom relation to restrict scope" do
      payment = enrollment.payments.first
      payment.update_columns(due_date: Date.today - 5, status: 2)

      student2    = create(:student, academy: academy)
      enrollment2 = create(:enrollment, student: student2, plan: plan)
      payment2    = enrollment2.payments.first
      payment2.update_columns(due_date: Date.today - 3, status: 2)

      # Pass a relation that only includes payment2
      scoped = described_class.new(academy, Payment.where(id: payment2.id)).call
      expect(scoped).to include(payment2)
      expect(scoped).not_to include(payment)
    end
  end
end
