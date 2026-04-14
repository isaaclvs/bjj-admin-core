class HealthRecord < ApplicationRecord
  include RiskAssessable

  belongs_to :student

  serialize :comorbidities, coder: JSON
  serialize :allergies, coder: JSON
  serialize :injuries, coder: JSON

  validates :lgpd_consent, acceptance: { message: "deve ser aceito" }
  validates :signed_at, presence: true, if: :signature_data?

  before_save :set_lgpd_consent_at

  private

  def set_lgpd_consent_at
    self.lgpd_consent_at = Time.current if lgpd_consent_changed? && lgpd_consent?
  end
end
