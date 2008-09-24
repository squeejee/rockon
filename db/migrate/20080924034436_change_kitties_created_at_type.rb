class ChangeKittiesCreatedAtType < ActiveRecord::Migration
  def self.up
    change_column :kitties, :created_at, :datetime
  end

  def self.down
    change_column :kitties, :created_at, :integer
  end
end
