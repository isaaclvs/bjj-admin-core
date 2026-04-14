class CreateAcademies < ActiveRecord::Migration[8.1]
  def change
    create_table :academies do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps
    end

    add_index :academies, :slug, unique: true
  end
end
