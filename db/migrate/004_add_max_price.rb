class AddMaxPrice < ActiveRecord::Migration
  def self.up
    add_column :bids, :max_price, :integer
  end

  def self.down
    remove_column :bids, :max_price
  end
end
