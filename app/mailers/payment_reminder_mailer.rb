class PaymentReminderMailer < ApplicationMailer
  def reminder(payment)
    @payment = payment
    @student = payment.student
    @academy = @student.academy

    mail(
      to: @student.email,
      subject: "Pagamento em atraso — #{@academy.name}"
    )
  end
end
