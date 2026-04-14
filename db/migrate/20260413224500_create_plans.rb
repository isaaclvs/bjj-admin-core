class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.references :academy, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :price_cents, null: false
      t.integer :interval, null: false, default: 0
      t.text :description
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
