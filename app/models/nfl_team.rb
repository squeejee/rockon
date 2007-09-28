# == Schema Information
# Schema version: 8
#
# Table name: nfl_teams
#
#  id            :integer(11)   not null, primary key
#  nfl_team_name :string(100)   
#  bye_week      :integer(11)   
#  nfl_team_code :string(3)     
#

class NflTeam < ActiveRecord::Base
  has_many :nfl_players
end
