require "rails_helper"

RSpec.describe PaymentReminderJob, type: :job do
  let(:academy)    { create(:academy) }
  let(:plan)       { create(:plan, academy: academy) }
  let(:student)    { create(:student, academy: academy) }
  let(:enrollment) { create(:enrollment, student: student, plan: plan) }

  def overdue_payment
    payment = enrollment.payments.first
    payment.update_columns(due_date: Date.today - 5, status: 2)
    payment
  end

  describe "#perform" do
    it "creates a NotificationLog for a student with overdue payment" do
      overdue_payment
      expect { described_class.new.perform }
        .to change(NotificationLog, :count).by(1)
    end

    it "creates the log with correct attributes" do
      overdue_payment
      described_class.new.perform

      log = NotificationLog.last
      expect(log.student).to eq(student)
      expect(log.notification_type).to eq("payment_reminder")
      expect(log.channel).to eq("email")
      expect(log.sent_at).to be_within(5.seconds).of(Time.current)
    end

    it "does not create a second notification if already notified today" do
      overdue_payment
      described_class.new.perform
      expect { described_class.new.perform }
        .not_to change(NotificationLog, :count)
    end

    it "does not create a notification for paid payments" do
      payment = enrollment.payments.first
      payment.update_columns(status: 1, paid_at: Date.today)

      expect { described_class.new.perform }
        .not_to change(NotificationLog, :count)
    end

    it "does not create a notification for pending future payments" do
      payment = enrollment.payments.first
      payment.update_columns(due_date: Date.today + 30, status: 0)

      expect { described_class.new.perform }
        .not_to change(NotificationLog, :count)
    end
  end
end
