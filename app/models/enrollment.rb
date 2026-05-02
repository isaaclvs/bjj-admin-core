class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :plan
  has_many :payments, dependent: :destroy

  enum :status, { active: 0, cancelled: 1, suspended: 2 }

  validates :started_at, presence: true
  validates :student_id, uniqueness: {
    scope: :plan_id,
    conditions: -> { active },
    message: "já possui matrícula ativa neste plano"
  }

  after_create :generate_first_payment

  private

  def generate_first_payment
    payments.create!(
      amount_cents: plan.price_cents,
      due_date: started_at,
      status: :pending
    )
  end
end
