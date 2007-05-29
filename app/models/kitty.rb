# == Schema Information
# Schema version: 5
#
# Table name: kitties
#
#  id              :integer(11)   not null, primary key
#  week_no         :integer(11)   
#  user_id         :integer(11)   
#  description     :string(200)   
#  league_owes     :decimal(19, 4 
#  league_due      :decimal(19, 4 
#  league_paid     :decimal(19, 4 
#  league_received :decimal(19, 4 
#  updated_at      :datetime      
#  created_at      :integer(11)   
#

class Kitty < ActiveRecord::Base
  belongs_to :user
end
