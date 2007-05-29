class AutoBid < ActiveRecord::Base
  belongs_to :user
  belongs_to :auction
end
