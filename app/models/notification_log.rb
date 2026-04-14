class NotificationLog < ApplicationRecord
  belongs_to :student

  validates :notification_type, presence: true
  validates :channel, presence: true
end
