# == Schema Information
# Schema version: 8
#
# Table name: nfl_players
#
#  id          :integer(11)   not null, primary key
#  last_name   :string(50)    
#  first_name  :string(50)    
#  position_id :integer(6)    
#  nfl_team_id :integer(11)   
#

class NflPlayer < ActiveRecord::Base
  has_many :auctions
  belongs_to :nfl_team
  belongs_to :position
  has_many :bids
  has_many :fantasy_players
  
  def display_name
    last_name + ', ' + first_name
  end
    
  def display_name_with_team_code
    last_name + ', ' + first_name + '--' + nfl_team.nfl_team_code
  end
  
  def self.find_by_position_id(position_id)
    if position_id.nil?
      find(:all, :include=>:nfl_team, :conditions => "nfl_players.id not in (select nfl_player_id from fantasy_players)", :order => "last_name, first_name asc")
    else
      find(:all, :include=>:nfl_team, :conditions => ["nfl_players.id not in (select nfl_player_id from fantasy_players) and position_id = ?", position_id], :order => "last_name, first_name asc")
    end
  end
    
  def self.find_by_user_id(user_id)
    find(:all, :conditions => ["fantasy_players.user_id = ?", user_id], :include => :fantasy_players,
         :order => "nfl_players.last_name, nfl_players.first_name")
  end
  
end
