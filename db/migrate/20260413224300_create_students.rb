class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.references :academy, null: false, foreign_key: true
      t.string :name, null: false
      t.string :cpf
      t.string :phone
      t.string :email
      t.integer :belt, default: 0
      t.date :birth_date
      t.string :emergency_contact_name
      t.string :emergency_contact_phone
      t.integer :status, null: false, default: 0
      t.date :enrolled_at

      t.timestamps
    end
  end
end
