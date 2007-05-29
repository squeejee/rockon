class FantasyPlayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :nfl_player
    
end
