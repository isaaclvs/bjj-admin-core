class PaymentReminderJob < ApplicationJob
  queue_as :default

  def perform
    Academy.find_each do |academy|
      OverduePaymentsQuery.new(academy).call.each do |payment|
        student = payment.student
        next if already_notified_today?(student)

        NotificationLog.create!(
          student: student,
          notification_type: "payment_reminder",
          channel: "email",
          sent_at: Time.current
        )

        PaymentReminderMailer.reminder(payment).deliver_later if student.email.present?
      end
    end
  end

  private

  def already_notified_today?(student)
    student.notification_logs
           .where(notification_type: "payment_reminder")
           .where(sent_at: Time.current.beginning_of_day..)
           .exists?
  end
end
