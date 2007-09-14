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
  
  def self.balance
    sql = <<SQL_STRING
            SELECT u.id as user_id, coalesce(u.first_name, "") as first_name, coalesce(u.last_name, "") as last_name,
            u.team_name, sum((coalesce(k.League_Owes, 0)+coalesce(k.League_Received, 0))-(coalesce(k.League_Due, 0)+coalesce(k.League_Paid, 0))) as balance 
            FROM users u 
            INNER JOIN kitties k ON u.id = k.user_id 
            group by u.id, u.team_name
            order by u.first_name, u.team_name  
SQL_STRING
    
    find_by_sql sql
  end
  

  def self.sum_league_due(user_id = current_user)
    return Kitty.sum(:league_due, :conditions => ["user_id = ?", user_id])
  end
  
  def self.sum_league_owes(user_id = current_user)
    return Kitty.sum(:league_owes, :conditions => ["user_id = ?", user_id])
  end
  
  def self.sum_league_received(user_id = current_user)
    return Kitty.sum(:league_received, :conditions => ["user_id = ?", user_id])
  end
  
  def self.sum_league_paid(user_id = current_user)
    return Kitty.sum(:league_paid, :conditions => ["user_id = ?", user_id])
  end
end
