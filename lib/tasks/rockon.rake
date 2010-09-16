namespace :rockon do

    desc "Generate default kitty data"
    task :create_initial_kitty => :environment do
      
      users = User.find :all
      
      users.each do |user|
        Kitty.create(
          :week_no => 1,
          :user_id => user.id,
          :description => "Entry Fee",
          :league_due => 80.00
          )
      end
      
      (1..16).each do |week_no|
        Kitty.create(:week_no => week_no, :description => "Weekly High Score", :league_owes => 10)
      end
      
      Kitty.create(:week_no => 14, :description => "4th Place", :league_owes => 20)
      Kitty.create(:week_no => 15, :description => "5th Place", :league_owes => 15)
      Kitty.create(:week_no => 16, :description => "6th Place", :league_owes => 10)
      Kitty.create(:week_no => 2, :description => "MyFantasyLeague.com", :league_owes => 70)
      Kitty.create(:week_no => 3, :description => "Trophy Updates", :league_owes => 15)

      
    end    
end