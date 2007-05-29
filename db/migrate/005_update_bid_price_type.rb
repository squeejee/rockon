class UpdateBidPriceType < ActiveRecord::Migration
  def self.up
    change_column :bids, :price, :integer
  end

  def self.down
  end
end
