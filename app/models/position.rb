# == Schema Information
# Schema version: 5
#
# Table name: positions
#
#  id             :integer(11)   not null, primary key
#  position_code  :string(50)    
#  position_name  :string(50)    
#  position_order :integer(11)   
#

class Position < ActiveRecord::Base
  has_many :nfl_players
end
