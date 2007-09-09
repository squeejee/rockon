class CreateJimUser < ActiveRecord::Migration
  def self.up
    u = User.new
    u.login="jim"
    u.commish=true
    u.password="password"
    u.password_confirmation="password"
    u.save
  end

  def self.down
  end
end
