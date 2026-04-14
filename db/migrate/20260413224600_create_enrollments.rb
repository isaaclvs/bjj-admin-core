class CreateEnrollments < ActiveRecord::Migration[8.1]
  def change
    create_table :enrollments do |t|
      t.references :student, null: false, foreign_key: true
      t.references :plan, null: false, foreign_key: true
      t.date :started_at, null: false
      t.date :expires_at
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
