class CreatePayments < ActiveRecord::Migration[8.1]
  def change
    create_table :payments do |t|
      t.references :enrollment, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.date :due_date, null: false
      t.date :paid_at
      t.integer :method, default: 0
      t.integer :status, null: false, default: 0
      t.text :notes

      t.timestamps
    end
  end
end
