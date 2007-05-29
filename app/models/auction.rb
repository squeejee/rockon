class Auction < ActiveRecord::Base
  has_many :bids
  belongs_to :user
  belongs_to :nfl_player  
  
  validates_presence_of :nfl_player_id, :on => :create, :message => "A player must be selected!"
end
