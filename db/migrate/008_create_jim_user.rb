class CreateJimUser < ActiveRecord::Migration
  def self.up
    [['jim', 'jim.mulholland@gmail.com', true], ['bill', 'bill@billdubrul.com'],['curtis', 'CJohnson@grothcorp.com'],
    ['frank', 'feverlyklm@yahoo.com'],['dwayne', 'johnsonda1@hotmail.com'],['jay', 'jjohnson7@gmail.com'],
    ['joe', 'jobu93ag@yahoo.com'],['len', 'psu1993@yahoo.com'],['matt', 'mafia93@yahoo.com'],['mike', 'mike.mulholland@gmail.com']].each do |login, email, commish|
      u = User.new
      u.login=login
      u.email = email
      u.commish=true if commish
      u.password="password"
      u.password_confirmation="password"
      u.save
    end
  end

  def self.down
  end
end
