class CreateUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :login, :string
    rename_column :users, :email_address, :email
    change_column :users, :password, :string, :limit => 40
    rename_column :users, :password,  :crypted_password  
    add_column :users, :salt, :string, :limit => 40
    add_column :users, :remember_token, :string
    add_column :users, :remember_token_expires_at, :datetime    
  end

  def self.down
    remove_column :users, :login
    remove_column :users, :salt
    remove_column :users, :remember_toke
    remove_column :users, :remember_token_expires_at    
  end
end
