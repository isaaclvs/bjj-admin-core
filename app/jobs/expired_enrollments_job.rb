class ExpiredEnrollmentsJob < ApplicationJob
  queue_as :default

  def perform
    Enrollment.active
              .where.not(expires_at: nil)
              .where(expires_at: ..Time.current.to_date)
              .find_each { |e| e.update!(status: :cancelled) }
  end
end
