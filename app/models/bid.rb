class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :user
  belongs_to :nfl_player  
end
