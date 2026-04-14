class Academy < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :students, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_many :payments, through: :students

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/ }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name.to_s.parameterize
  end
end
