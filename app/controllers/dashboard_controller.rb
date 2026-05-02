class DashboardController < ApplicationController
  def index
    @students_count = current_academy.students.active.count
    @risk_students  = current_academy.students.at_risk.limit(5)

    if current_user.owner?
      @overdue_count = OverduePaymentsQuery.new(current_academy).call.count
      @revenue_month = current_academy.payments.paid_this_month.sum(:amount_cents) / 100.0
    end
  end
end
