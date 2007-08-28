class CreateLeagueTable < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.column :name, :string
      t.column :first_week_date, :datetime
      t.column :bid_end_day, :int
      t.column :bid_end_time, :int
      t.column :last_bid_week, :int
      t.column :updated_at, :datetime
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :leagues
  end
end
