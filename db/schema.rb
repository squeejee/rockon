# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080924034436) do

  create_table "auctions", :force => true do |t|
    t.integer  "nfl_player_id", :limit => 6
    t.integer  "week_no",       :limit => 11
    t.datetime "updated_at"
    t.datetime "created_at"
    t.datetime "expiration"
  end

  create_table "auto_bids", :force => true do |t|
    t.integer  "auction_id", :limit => 11
    t.integer  "user_id",    :limit => 11
    t.decimal  "max_bid",                  :precision => 19, :scale => 4
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "bids", :force => true do |t|
    t.integer  "auction_id",    :limit => 11
    t.integer  "user_id",       :limit => 11
    t.integer  "nfl_player_id", :limit => 11
    t.integer  "price",         :limit => 11
    t.datetime "updated_at"
    t.datetime "created_at"
    t.integer  "max_price",     :limit => 11
  end

  create_table "constants", :id => false, :force => true do |t|
    t.datetime "start_date"
    t.integer  "bid_end_day",      :limit => 11
    t.integer  "bid_end_time",     :limit => 11
    t.integer  "last_bid_week",    :limit => 11
    t.integer  "starter_end_date", :limit => 11
    t.integer  "start_end_time",   :limit => 11
  end

  create_table "fantasy_players", :force => true do |t|
    t.integer "user_id",       :limit => 11
    t.integer "nfl_player_id", :limit => 11
    t.integer "position_id",   :limit => 11
    t.integer "updated_at",    :limit => 11
    t.integer "created_at",    :limit => 11
    t.integer "week_acquired", :limit => 11
    t.integer "week_released", :limit => 11
  end

  create_table "kitties", :force => true do |t|
    t.integer  "week_no",         :limit => 11
    t.integer  "user_id",         :limit => 11
    t.string   "description",     :limit => 200
    t.decimal  "league_owes",                    :precision => 19, :scale => 4
    t.decimal  "league_due",                     :precision => 19, :scale => 4
    t.decimal  "league_paid",                    :precision => 19, :scale => 4
    t.decimal  "league_received",                :precision => 19, :scale => 4
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "leagues", :force => true do |t|
    t.string   "name"
    t.datetime "first_week_date"
    t.integer  "bid_end_day",     :limit => 11
    t.integer  "bid_end_time",    :limit => 11
    t.integer  "last_bid_week",   :limit => 11
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "lineupdetails", :force => true do |t|
    t.integer "Lineup_Id",    :limit => 11
    t.integer "NFLPlayer_Id", :limit => 11
  end

  create_table "lineups", :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "week_no",    :limit => 11
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "nfl_players", :force => true do |t|
    t.string  "last_name",   :limit => 50
    t.string  "first_name",  :limit => 50
    t.integer "position_id", :limit => 6
    t.integer "nfl_team_id", :limit => 11
  end

  create_table "nfl_teams", :force => true do |t|
    t.string  "nfl_team_name", :limit => 100
    t.integer "bye_week",      :limit => 11
    t.string  "nfl_team_code", :limit => 3
  end

  create_table "positions", :force => true do |t|
    t.string  "position_code",  :limit => 50
    t.string  "position_name",  :limit => 50
    t.integer "position_order", :limit => 11
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "team_name",                 :limit => 50
    t.string   "crypted_password",          :limit => 40
    t.string   "last_name",                 :limit => 50
    t.string   "first_name",                :limit => 50
    t.string   "email",                     :limit => 50
    t.boolean  "commish",                                 :default => false, :null => false
    t.integer  "login_no",                  :limit => 11
    t.datetime "last_login"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.string   "login"
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

end
