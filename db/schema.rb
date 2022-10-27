# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_26_190836) do

  create_table "cards", primary_key: "cid", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "uid"
    t.string "title", limit: 80
    t.string "source", limit: 100
    t.string "description", limit: 300
    t.integer "status", default: 0
    t.bigint "used_time"
    t.integer "stars"
    t.datetime "create_time"
    t.datetime "update_time"
    t.datetime "schedule_time"
  end

  create_table "user_log_infos", primary_key: "username", id: :string, limit: 50, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "password", limit: 50
    t.string "email", limit: 50
    t.bigint "uid"
  end

  create_table "user_profiles", primary_key: "uid", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username", limit: 50
    t.string "school", limit: 50
    t.string "company", limit: 50
    t.string "bio", limit: 200
    t.string "avatar", limit: 100
    t.string "city", limit: 50
    t.date "expiration_date"
    t.integer "status", default: 0
  end

  create_table "user_to_cards", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "uid"
    t.bigint "cid"
    t.index ["uid"], name: "index_user_to_cards_on_uid"
  end

end
