class User < ApplicationRecord
  attr_accessor :remember_token   
      #let User class to handle variable (remember_token)
      #attr_accessor defines getter (method to get data) and setter (method to input data) for specific properties.
      #it lets access to @remember_token  
  before_save {email.downcase!}   #{email.downcase!} = {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 244}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  def User.digest(string)   #class method. save it in database to use for all users
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost   # cost = difficulty to calculate hash
    BCrypt::Password.create(string, cost:  cost)
  end
  
  def User.new_token   #class method. save it in database to use for all users
    SecureRandom.urlsafe_base64
  end
  
  def remember   #create new_token and save as remember_digest
    self.remember_token = User.new_token    #self... = User's (a user's) ...
    update_attribute(:remember_digest, User.digest(remember_token))
          #update remember_digest to encrypted remember_token
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
          #stop authentification for when logged out in dif browser
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
          # = BCrypt::Password.new(remember_digest) == remember_token
          # remember_digest = self.remember_digest = a user's remember_digest
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end
