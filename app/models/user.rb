class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :academy

  enum :role, { owner: 0, teacher: 1 }

  validates :role, presence: true
end
