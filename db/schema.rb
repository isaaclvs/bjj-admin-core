# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_13_224800) do
  create_table "academies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_academies_on_slug", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "expires_at"
    t.integer "plan_id", null: false
    t.date "started_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_enrollments_on_plan_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "health_records", force: :cascade do |t|
    t.text "allergies"
    t.string "blood_type"
    t.text "comorbidities"
    t.datetime "created_at", null: false
    t.text "injuries"
    t.boolean "lgpd_consent", default: false
    t.datetime "lgpd_consent_at"
    t.text "medication_notes"
    t.boolean "risk_flag", default: false
    t.text "risk_notes"
    t.text "signature_data"
    t.datetime "signed_at"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.boolean "uses_medication", default: false
    t.index ["student_id"], name: "index_health_records_on_student_id"
  end

  create_table "notification_logs", force: :cascade do |t|
    t.string "channel", null: false
    t.datetime "created_at", null: false
    t.string "notification_type", null: false
    t.datetime "sent_at"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_notification_logs_on_student_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.date "due_date", null: false
    t.integer "enrollment_id", null: false
    t.integer "method", default: 0
    t.text "notes"
    t.date "paid_at"
    t.integer "status", default: 0, null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["enrollment_id"], name: "index_payments_on_enrollment_id"
    t.index ["student_id"], name: "index_payments_on_student_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "academy_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "interval", default: 0, null: false
    t.string "name", null: false
    t.integer "price_cents", null: false
    t.datetime "updated_at", null: false
    t.index ["academy_id"], name: "index_plans_on_academy_id"
  end

  create_table "students", force: :cascade do |t|
    t.integer "academy_id", null: false
    t.integer "belt", default: 0
    t.date "birth_date"
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.date "enrolled_at"
    t.string "name", null: false
    t.string "phone"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["academy_id"], name: "index_students_on_academy_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "academy_id", null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["academy_id"], name: "index_users_on_academy_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "enrollments", "plans"
  add_foreign_key "enrollments", "students"
  add_foreign_key "health_records", "students"
  add_foreign_key "notification_logs", "students"
  add_foreign_key "payments", "enrollments"
  add_foreign_key "payments", "students"
  add_foreign_key "plans", "academies"
  add_foreign_key "students", "academies"
  add_foreign_key "users", "academies"
end
