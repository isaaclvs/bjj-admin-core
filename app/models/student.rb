class Student < ApplicationRecord
  include AcademyScoped

  belongs_to :academy
  has_one :health_record, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :payments, through: :enrollments
  has_many :notification_logs, dependent: :destroy
  has_many :plans, through: :enrollments

  enum :belt, { white: 0, blue: 1, purple: 2, brown: 3, black: 4 }
  enum :status, { active: 0, inactive: 1, suspended: 2 }

  validates :name, presence: true
  validates :cpf, uniqueness: { scope: :academy_id }, allow_blank: true

  scope :with_overdue_payments, -> {
    joins(enrollments: :payments).where(payments: { status: :overdue }).distinct
  }

  scope :at_risk, -> { joins(:health_record).where(health_records: { risk_flag: true }) }
end
