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

ActiveRecord::Schema[7.1].define(version: 2024_09_14_140219) do
  create_table "boards", force: :cascade do |t|
    t.integer "entry_id", null: false
    t.integer "number"
    t.datetime "played_at"
    t.string "north", limit: 128
    t.string "south", limit: 128
    t.string "east", limit: 128
    t.string "west", limit: 128
    t.string "result", limit: 16
    t.integer "points"
    t.decimal "score"
    t.string "movie_url", limit: 1024
    t.string "lin_url", limit: 1024
    t.string "traveller_url", limit: 1024
    t.string "lin_data", limit: 1024
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry_id"], name: "index_boards_on_entry_id"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "tournament_id", null: false
    t.string "player", limit: 128
    t.date "played_at"
    t.decimal "score"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tournament_id"], name: "index_entries_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "guid", limit: 64
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "tourney_date"
    t.string "name", limit: 256
    t.integer "entries_count"
  end

  add_foreign_key "boards", "entries"
  add_foreign_key "entries", "tournaments"
end
