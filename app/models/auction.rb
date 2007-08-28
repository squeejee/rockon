# == Schema Information
# Schema version: 5
#
# Table name: auctions
#
#  id            :integer(11)   not null, primary key
#  nfl_player_id :integer(6)    
#  week_no       :integer(11)   
#  updated_at    :datetime      
#  created_at    :datetime      
#  expiration    :datetime      
#

class Auction < ActiveRecord::Base
  has_many :bids
  belongs_to :user
  belongs_to :nfl_player  
  
  validates_presence_of :nfl_player_id, :on => :save, :message => "must be selected!"
  validates_associated :bids, :on => :save      
  
  def active?
    if League.current_week == week_no && Time.now.wday < League.bid_end_day 
      return true
    elsif League.current_week == week_no && Time.now.wday == League.bid_end_day && Time.now.hour < League.bid_end_time
      return true
    else
      return false
    end
  end
  
end
