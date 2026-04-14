class CreateHealthRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :health_records do |t|
      t.references :student, null: false, foreign_key: true
      t.text :comorbidities
      t.text :allergies
      t.text :injuries
      t.string :blood_type
      t.boolean :uses_medication, default: false
      t.text :medication_notes
      t.boolean :risk_flag, default: false
      t.text :risk_notes
      t.datetime :signed_at
      t.text :signature_data
      t.boolean :lgpd_consent, default: false
      t.datetime :lgpd_consent_at

      t.timestamps
    end
  end
end
