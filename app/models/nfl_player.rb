# == Schema Information
# Schema version: 5
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
#  has_many :auctions
  belongs_to :nfl_team
  belongs_to :position
#  has_many :bids
#  has_many :fantasy_players
  
  def display_name
    first_name + ' ' + last_name
  end
  
  def self.find_by_position_id(position_id)
    if position_id.nil?
      find(:all)
    else
      find(:all, :conditions => ["position_id = ?", position_id])
    end
  end
    
  def self.find_by_user_id(user_id)
    find(:all, :conditions => ["fantasy_players.user_id = ?", user_id], :include => :fantasy_players,
         :order => "nfl_players.last_name, nfl_players.first_name")
  end
  
end
