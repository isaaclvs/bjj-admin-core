module RiskAssessable
  extend ActiveSupport::Concern

  RISK_CONDITIONS = %w[
    hipertensão hipertensao diabetes cardíaco cardiaco
    lombar epilepsia asma marca-passo marcapasso
  ].freeze

  included do
    before_save :assess_risk
  end

  private

  def assess_risk
    self.risk_flag = risk_condition_present?
  end

  def risk_condition_present?
    risk_text_fields.any? { |text| mentions_risk?(text) }
  end

  def risk_text_fields
    [ comorbidities, injuries, medication_notes ].flatten.compact
  end

  def mentions_risk?(text)
    RISK_CONDITIONS.any? { |condition| text.to_s.downcase.include?(condition) }
  end
end
