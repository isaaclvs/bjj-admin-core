class Payment < ApplicationRecord
  belongs_to :enrollment
  belongs_to :student

  enum :method, { pix: 0, cash: 1, card: 2, other: 3 }
  enum :status, { pending: 0, paid: 1, overdue: 2, cancelled: 3 }

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :due_date, presence: true

  scope :overdue, -> {
    where(status: :overdue)
      .or(where(status: :pending).where(due_date: ..Date.today))
  }
  scope :paid_this_month, -> { paid.where(paid_at: Date.current.beginning_of_month..) }

  before_save :mark_overdue_if_past_due

  def amount
    amount_cents / 100.0
  end

  private

  def mark_overdue_if_past_due
    return unless pending? && due_date < Date.today
    self.status = :overdue
  end
end
