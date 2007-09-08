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
  
  #####
  has_one :top_bidder, :class_name => 'Bid', :order => 'price desc'
  #####
  
  belongs_to :user
  belongs_to :nfl_player  
  
  validates_presence_of :nfl_player_id, :on => :save, :message => "must be selected!"
  validates_associated :bids, :on => :save      
  
  #This is to determine if a specific auction is active
  def active?
    if League.active? && League.current_week == week_no && Time.now < self.expiration
      return true
#    elsif League.active? && League.current_week == week_no && Time.now.wday == self.expiration.wday && Time.now.hour < self.expiration.hour
#      return true
    else
      return false
    end
  end  
  
  #This is created to determine if auctions are still active for the week in general.
  def self.active?
    if League.active? && Time.now.wday < League.bid_end_day 
      return true
    elsif League.active? && Time.now.wday == League.bid_end_day && Time.now.hour < League.bid_end_time
      return true
    else
      return false
    end    
  end
  
#  def top_bidder
#    self.bids.find_top_bidder()
#  end
  
  def top_bidder?
    top_bidder.user.id == current_user
  end
  
  def hidden_auction
    self.bids.count == 1 && self.active?
  end
end
