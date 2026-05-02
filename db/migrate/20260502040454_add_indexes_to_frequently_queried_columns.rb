class AddIndexesToFrequentlyQueriedColumns < ActiveRecord::Migration[8.1]
  def change
    add_index :payments, :status
    add_index :payments, :due_date
    add_index :payments, :paid_at
    add_index :enrollments, :status
    add_index :students, :status
    add_index :students, :belt
  end
end
