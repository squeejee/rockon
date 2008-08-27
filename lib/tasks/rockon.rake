namespace :rockon do

    desc "Generate default kitty data"
    task :create_initial_kitty => :environment do
      
      users = User.find :all
      
      users.each do |user|
        Kitty.create(
          :week_no => 1,
          :user_id => user.id,
          :description => "Entry Fee",
          :league_due => 60.00
          )
      end
    end    
end