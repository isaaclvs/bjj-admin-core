class RemoveStudentIdFromPayments < ActiveRecord::Migration[8.1]
  def change
    remove_reference :payments, :student, foreign_key: true
  end
end
