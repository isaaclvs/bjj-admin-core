class CreateNotificationLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :notification_logs do |t|
      t.references :student, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.string :channel, null: false
      t.datetime :sent_at

      t.timestamps
    end
  end
end
