# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140515081603) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id",                         null: false
    t.integer  "player_id",                       null: false
    t.string   "state",      default: "unlocked"
  end

  create_table "games", force: true do |t|
    t.string   "phase",      default: "setup_players"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "turn"
    t.integer  "winner"
  end

  create_table "games_players", force: true do |t|
    t.integer  "player_id",  null: false
    t.integer  "game_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", force: true do |t|
    t.integer  "board_id",                     null: false
    t.string   "kind",                         null: false
    t.string   "state",      default: "unset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "squares", force: true do |t|
    t.string   "x",                            null: false
    t.string   "y",                            null: false
    t.string   "state",      default: "empty"
    t.integer  "board_id",                     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id",                      null: false
    t.integer  "ship_id"
  end

end
