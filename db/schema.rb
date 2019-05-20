# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 24) do

  create_table "entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "age", null: false
    t.float "burden_weight", null: false
    t.float "final_600m_time"
    t.string "jockey"
    t.integer "number", null: false
    t.string "order", null: false
    t.integer "prize_money"
    t.string "sex", null: false
    t.float "weight"
    t.float "weight_diff"
    t.integer "horse_id"
    t.integer "race_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id", "number"], name: "index_entries_on_race_id_and_number", unique: true
  end

  create_table "features", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "age", null: false
    t.float "average_prize_money", null: false
    t.integer "blank"
    t.float "burden_weight", null: false
    t.string "direction"
    t.integer "distance", null: false
    t.float "distance_diff", null: false
    t.integer "entry_times", null: false
    t.string "grade", default: "N", null: false
    t.string "horse_id", null: false
    t.string "jockey"
    t.float "last_race_final_600m_time"
    t.integer "last_race_order"
    t.integer "month", null: false
    t.integer "number", null: false
    t.string "place", null: false
    t.string "race_id", null: false
    t.float "rate_within_third"
    t.integer "round", null: false
    t.string "running_style", null: false
    t.integer "second_last_race_order"
    t.string "sex", null: false
    t.string "track", null: false
    t.string "weather", null: false
    t.float "weight"
    t.float "weight_diff"
    t.float "weight_per"
    t.integer "win_times", null: false
    t.boolean "won", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "horses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "horse_id", null: false
    t.string "running_style", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["horse_id"], name: "index_horses_on_horse_id", unique: true
  end

  create_table "races", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "direction"
    t.integer "distance", null: false
    t.string "grade"
    t.string "place", null: false
    t.string "race_id", null: false
    t.integer "round", null: false
    t.datetime "start_time", null: false
    t.string "track", null: false
    t.string "weather", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place", "start_time"], name: "index_races_on_place_and_start_time", unique: true
  end

end
