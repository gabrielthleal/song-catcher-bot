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

ActiveRecord::Schema.define(version: 2020_09_09_225046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "spotify_users", force: :cascade do |t|
    t.string "access_token"
    t.string "refresh_token"
    t.bigint "user_id", null: false
    t.string "spotify_id"
    t.string "playlist_id"
    t.index ["user_id"], name: "index_spotify_users_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "telegram_id"
    t.string "first_name"
    t.string "last_name"
    t.jsonb "bot_command_data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "language", default: "en"
  end

  add_foreign_key "spotify_users", "users"
end
