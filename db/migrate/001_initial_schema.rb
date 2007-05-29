class InitialSchema < ActiveRecord::Migration
  def self.up
    
    create_table "auctions", :force => true do |t|
      t.column "nfl_player_id", :integer,  :limit => 6
      t.column "week_no",       :integer
      t.column "updated_at",    :datetime
      t.column "created_at",    :datetime
      t.column "expiration",    :datetime
    end

    create_table "auto_bids", :force => true do |t|
      t.column "auction_id", :integer
      t.column "user_id",    :integer
      t.column "max_bid",    :decimal,  :precision => 19, :scale => 4
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
    end

    create_table "bids", :force => true do |t|
      t.column "auction_id",    :integer
      t.column "user_id",       :integer
      t.column "nfl_player_id", :integer
      t.column "price",         :decimal,  :precision => 19, :scale => 4
      t.column "updated_at",    :datetime
      t.column "created_at",    :datetime
    end

    create_table "constants", :id => false, :force => true do |t|
      t.column "start_date",       :datetime
      t.column "bid_end_day",      :integer
      t.column "bid_end_time",     :integer
      t.column "last_bid_week",    :integer
      t.column "starter_end_date", :integer
      t.column "start_end_time",   :integer
    end

    create_table "fantasy_players", :force => true do |t|
      t.column "user_id",       :integer
      t.column "nfl_player_id", :integer
      t.column "position_id",   :integer
      t.column "updated_at",    :integer
      t.column "created_at",    :integer
      t.column "week_acquired", :integer
      t.column "week_released", :integer
    end

    create_table "kitties", :force => true do |t|
      t.column "week_no",         :integer
      t.column "user_id",         :integer
      t.column "description",     :string,   :limit => 200
      t.column "league_owes",     :decimal,                 :precision => 19, :scale => 4
      t.column "league_due",      :decimal,                 :precision => 19, :scale => 4
      t.column "league_paid",     :decimal,                 :precision => 19, :scale => 4
      t.column "league_received", :decimal,                 :precision => 19, :scale => 4
      t.column "updated_at",      :datetime
      t.column "created_at",      :integer
    end

    create_table "lineupdetails", :force => true do |t|
      t.column "Lineup_Id",    :integer
      t.column "NFLPlayer_Id", :integer
    end

    create_table "lineups", :force => true do |t|
      t.column "user_id",    :integer
      t.column "week_no",    :integer
      t.column "updated_at", :datetime
      t.column "created_at", :datetime
    end

    create_table "nfl_players", :force => true do |t|
      t.column "last_name",   :string,  :limit => 50
      t.column "first_name",  :string,  :limit => 50
      t.column "position_id", :integer, :limit => 6
      t.column "nfl_team_id", :integer
    end

    create_table "nfl_teams", :force => true do |t|
      t.column "nfl_team_name", :string,  :limit => 100
      t.column "bye_week",      :integer
      t.column "nfl_team_code", :string,  :limit => 3
    end

    create_table "positions", :force => true do |t|
      t.column "position_code",  :string,  :limit => 50
      t.column "position_name",  :string,  :limit => 50
      t.column "position_order", :integer
    end

    create_table "users", :force => true do |t|
      t.column "team_name",     :string,   :limit => 50
      t.column "password",      :string,   :limit => 50
      t.column "last_name",     :string,   :limit => 50
      t.column "first_name",    :string,   :limit => 50
      t.column "email_address", :string,   :limit => 50
      t.column "commish",       :boolean,                :default => false, :null => false
      t.column "login_no",      :integer
      t.column "last_login",    :datetime
      t.column "updated_at",    :datetime
      t.column "created_at",    :datetime
    end
    
  end

  def self.down
  end
end
