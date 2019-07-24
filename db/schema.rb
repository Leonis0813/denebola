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

ActiveRecord::Schema.define(version: 29) do

  create_table "bracket_quinellas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "entry1_id", null: false
    t.integer "entry2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry1_id"], name: "fk_rails_58ff7ed11e"
    t.index ["entry2_id"], name: "fk_rails_0713565dc9"
  end

  create_table "entries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "age", null: false
    t.float "burden_weight", null: false
    t.float "final_600m_time"
    t.string "jockey"
    t.integer "number", null: false
    t.string "order", null: false
    t.integer "prize_money", null: false
    t.string "sex", null: false
    t.float "weight"
    t.float "weight_diff"
    t.integer "horse_id"
    t.integer "race_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["horse_id", "race_id"], name: "index_entries_on_horse_id_and_race_id", unique: true
    t.index ["race_id", "number"], name: "index_entries_on_race_id_and_number", unique: true
  end

  create_table "exactas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "first_place_id", null: false
    t.integer "second_place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_place_id"], name: "fk_rails_96fe7cd245"
    t.index ["second_place_id"], name: "fk_rails_d8b33e3691"
  end

  create_table "features", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "age", null: false
    t.float "average_prize_money", null: false
    t.integer "blank", null: false
    t.float "burden_weight", null: false
    t.string "direction", null: false
    t.integer "distance", null: false
    t.float "distance_diff", null: false
    t.integer "entry_times", null: false
    t.string "grade", default: "N", null: false
    t.string "horse_id", null: false
    t.integer "last_race_order", null: false
    t.integer "month", null: false
    t.integer "number", null: false
    t.string "place", null: false
    t.string "race_id", null: false
    t.float "rate_within_third", null: false
    t.integer "round", null: false
    t.string "running_style", null: false
    t.integer "second_last_race_order", null: false
    t.string "sex", null: false
    t.string "track", null: false
    t.string "weather", null: false
    t.float "weight", null: false
    t.float "weight_diff", null: false
    t.float "weight_per", null: false
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

  create_table "quinella_places", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "entry1_id", null: false
    t.integer "entry2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry1_id"], name: "fk_rails_a980b645c1"
    t.index ["entry2_id"], name: "fk_rails_193526d5fc"
  end

  create_table "quinellas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "entry1_id", null: false
    t.integer "entry2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry1_id"], name: "fk_rails_3a74dde86c"
    t.index ["entry2_id"], name: "fk_rails_e49b528035"
  end

  create_table "races", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "direction", null: false
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
    t.index ["race_id"], name: "index_races_on_race_id", unique: true
  end

  create_table "shows", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trifectas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "first_place_id", null: false
    t.integer "second_place_id", null: false
    t.integer "third_place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first_place_id"], name: "fk_rails_cf2ae3cc71"
    t.index ["second_place_id"], name: "fk_rails_9b89281242"
    t.index ["third_place_id"], name: "fk_rails_6f14d84ad4"
  end

  create_table "trios", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "entry1_id", null: false
    t.integer "entry2_id", null: false
    t.integer "entry3_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entry1_id"], name: "fk_rails_44ef9d515a"
    t.index ["entry2_id"], name: "fk_rails_722471329f"
    t.index ["entry3_id"], name: "fk_rails_17f52249b0"
  end

  create_table "wins", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.float "odds", null: false
    t.integer "favorite", null: false
    t.integer "race_id", null: false
    t.integer "entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bracket_quinellas", "entries", column: "entry1_id"
  add_foreign_key "bracket_quinellas", "entries", column: "entry2_id"
  add_foreign_key "exactas", "entries", column: "first_place_id"
  add_foreign_key "exactas", "entries", column: "second_place_id"
  add_foreign_key "quinella_places", "entries", column: "entry1_id"
  add_foreign_key "quinella_places", "entries", column: "entry2_id"
  add_foreign_key "quinellas", "entries", column: "entry1_id"
  add_foreign_key "quinellas", "entries", column: "entry2_id"
  add_foreign_key "trifectas", "entries", column: "first_place_id"
  add_foreign_key "trifectas", "entries", column: "second_place_id"
  add_foreign_key "trifectas", "entries", column: "third_place_id"
  add_foreign_key "trios", "entries", column: "entry1_id"
  add_foreign_key "trios", "entries", column: "entry2_id"
  add_foreign_key "trios", "entries", column: "entry3_id"
end
