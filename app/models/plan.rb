class Plan < ApplicationRecord
  include AcademyScoped

  belongs_to :academy
  has_many :enrollments, dependent: :restrict_with_error

  enum :interval, { monthly: 0, quarterly: 1, semiannual: 2 }

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than: 0 }

  scope :active, -> { where(active: true) }

  def price
    price_cents / 100.0
  end
end
