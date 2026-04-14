class PaymentReminderJob < ApplicationJob
  queue_as :default

  def perform
    overdue_payments.each do |payment|
      next if already_notified_today?(payment.student)

      NotificationLog.create!(
        student: payment.student,
        notification_type: "payment_reminder",
        channel: "email",
        sent_at: Time.current
      )

      # PaymentReminderMailer.reminder(payment).deliver_later
    end
  end

  private

  def overdue_payments
    Payment.overdue.includes(:student)
  end

  def already_notified_today?(student)
    student.notification_logs
           .where(notification_type: "payment_reminder")
           .where(sent_at: Date.today.beginning_of_day..)
           .exists?
  end
end
