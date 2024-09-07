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

ActiveRecord::Schema[7.0].define(version: 2024_09_06_171503) do
  create_table "challenges", force: :cascade do |t|
    t.string "name"
    t.integer "creator_id", null: false
    t.date "start_date"
    t.string "challenge_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.boolean "active"
    t.boolean "archive"
    t.index ["creator_id"], name: "index_challenges_on_creator_id"
  end

  create_table "logs", force: :cascade do |t|
    t.date "date_of_set"
    t.integer "reps_in_set"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "challenge_id"
    t.boolean "completed_the_day", default: false, null: false
    t.integer "user_id"
    t.index ["challenge_id"], name: "index_logs_on_challenge_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "challenge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_participations_on_challenge_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.boolean "visibility", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "challenges", "users", column: "creator_id"
  add_foreign_key "logs", "challenges"
  add_foreign_key "logs", "users"
  add_foreign_key "participations", "challenges"
  add_foreign_key "participations", "users"
end
