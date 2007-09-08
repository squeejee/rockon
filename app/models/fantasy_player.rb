# == Schema Information
# Schema version: 5
#
# Table name: fantasy_players
#
#  id            :integer(11)   not null, primary key
#  user_id       :integer(11)   
#  nfl_player_id :integer(11)   
#  position_id   :integer(11)   
#  updated_at    :integer(11)   
#  created_at    :integer(11)   
#  week_acquired :integer(11)   
#  week_released :integer(11)   
#

class FantasyPlayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :nfl_player
end