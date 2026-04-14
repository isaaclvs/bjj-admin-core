class OverduePaymentsQuery
  def initialize(academy, relation = Payment.all)
    @academy  = academy
    @relation = relation
  end

  def call
    @relation
      .joins(student: :academy)
      .where(academies: { id: @academy.id })
      .overdue
      .includes(:student, :enrollment)
      .order(:due_date)
  end
end
