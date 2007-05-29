# == Schema Information
# Schema version: 5
#
# Table name: bids
#
#  id            :integer(11)   not null, primary key
#  auction_id    :integer(11)   
#  user_id       :integer(11)   
#  nfl_player_id :integer(11)   
#  price         :integer(11)   
#  updated_at    :datetime      
#  created_at    :datetime      
#  max_price     :integer(11)   
#

class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user
  belongs_to :nfl_player  
  
  
def self.find_top_bidder()  
  #We use the following instead of "maximum()" in case two users have the same top bid.
  #In this case, the first bid entered takes priority.
  find(:first, :order => 'price desc, id asc')
end
end
