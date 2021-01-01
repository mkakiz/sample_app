class User < ApplicationRecord
  before_save {email.downcase!}   #{email.downcase!} = {self.email = email.downcase}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 244}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  
  def User.digest(string)   #class method. let it to use all users
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost   # cost = difficulty to calculate hash
    BCrypt::Password.create(string, cost:  cost)
  end
end
