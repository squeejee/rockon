# == Schema Information
# Schema version: 8
#
# Table name: auto_bids
#
#  id         :integer(11)   not null, primary key
#  auction_id :integer(11)   
#  user_id    :integer(11)   
#  max_bid    :decimal(19, 4 
#  updated_at :datetime      
#  created_at :datetime      
#

class AutoBid < ActiveRecord::Base
  belongs_to :user
  belongs_to :auction
end
