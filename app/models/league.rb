class League < ActiveRecord::Base
  include LeaguesHelper
  has_many :users
  has_many :auctions
  
  # We need to require date to do some date manipulation logic
  require 'date'
  
  def self.nfl_start_week
    league = League.find :first
    nfl_start_week = get_week(league.first_week_date)  
  end
  
  def self.bid_end_day
    league = League.find :first
    return league.bid_end_day
  end

  def self.bid_end_time
    league = League.find :first
    return league.bid_end_time
  end

  def self.last_bid_week
    league = League.find :first
    return league.last_bid_week
  end
    
  def self.current_week    
    current_date = Time.now
    
    # In order for the calculation to work correctly, we have to 
    # hard-code in a "-2" here.
    nfl_start_week_of_year = self.nfl_start_week - 2
    current_week_of_year = get_week(current_date)
    nfl_week_no = current_week_of_year - nfl_start_week_of_year
    
    if nfl_week_no < 1
      1
    else
      nfl_week_no
    end
  end  
  
  def self.active?    
      self.current_week <= League.last_bid_week
  end
  
  def self.get_week(date)    
    new_date = Date.new(date.year, date.month, date.day)
    week_no = new_date.cweek
    
    # The cweek returns the "commercial week" which starts on Monday.
    # If the day of the week is 0 (Sunday), we will add a week so our week
    # still starts on Sundays.
    new_date.wday == 0 ? week_no + 1 : week_no
  end
  
  def self.auction_end_date
    current_date = Time.now    
    days_until_expiration = current_date.wday - League.bid_end_day    
    
    if days_until_expiration >= 0
      expiration_date = current_date + days_until_expiration.days
      
      #Set the end date to 
      return DateTime.new(expiration_date.year, expiration_date.month, expiration_date.day, self.bid_end_time, 0, 0)
    end

  end

end
