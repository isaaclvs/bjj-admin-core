class OverduePaymentsQuery
  def initialize(academy, relation = Payment.all)
    @academy  = academy
    @relation = relation
  end

  def call
    @relation
      .joins(enrollment: { student: :academy })
      .where(academies: { id: @academy.id })
      .overdue
      .includes(enrollment: [ :student, :plan ])
      .order(:due_date)
  end
end
