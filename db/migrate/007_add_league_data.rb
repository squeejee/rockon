class AddLeagueData < ActiveRecord::Migration
  def self.up
    l = League.new
    l.name="Rock On"
    l.first_week_date = "2008-09-07"
    l.bid_end_day = 3
    l.bid_end_time = 22
    l.last_bid_week = 16
    l.save
  end

  def self.down
  end
end
