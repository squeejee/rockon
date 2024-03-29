# == Schema Information
# Schema version: 8
#
# Table name: users
#
#  id                        :integer(11)   not null, primary key
#  team_name                 :string(50)    
#  crypted_password          :string(40)    
#  last_name                 :string(50)    
#  first_name                :string(50)    
#  email                     :string(50)    
#  commish                   :boolean(1)    not null
#  login_no                  :integer(11)   
#  last_login                :datetime      
#  updated_at                :datetime      
#  created_at                :datetime      
#  login                     :string(255)   
#  salt                      :string(40)    
#  remember_token            :string(255)   
#  remember_token_expires_at :datetime      
#

require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  
  has_many :fantasy_players
  has_many :bids
  has_many :kitties

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?, :on => :create
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def full_name
    unless first_name.nil? || last_name.nil? || first_name.empty? || last_name.empty?
      "#{first_name} #{last_name}"
    else
      login
    end
  end
  
  def to_label
    full_name
  end
  
   def User.generate_password
     ( (1..8).collect { (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }.join.upcase.gsub(/[0O]/, "X")).downcase!
   end
 
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
