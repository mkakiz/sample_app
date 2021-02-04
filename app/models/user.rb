class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
      #let User class to handle variable (remember_token, activation_token)
      #attr_accessor defines getter (method to get data) and setter (method to input data) for specific properties.
      #it lets access to @remember_token, @activation_token
  before_save :downcase_email   #downcase_email = {email.downcase!} = {self.email = email.downcase}
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 244}, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true  
        #"allow_nil: true" let update without password.
        #has_secure_password validate input password and not let password nil at signup
  
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
  
  #def authenticated?(remember_token)   #remember_token = = User.new_token
  #  return false if remember_digest.nil?
  #        #stop authentification for when logged out in dif browser
  #  BCrypt::Password.new(remember_digest).is_password?(remember_token)
          # = BCrypt::Password.new(remember_digest) == remember_token
          # is_password? is used instead of ==
          # remember_digest = self.remember_digest = a user's remember_digest
  #end
  
  def authenticated?(attribute, token)  
    digest = self.send("#{attribute}_digest")   # self.send("attribute_digest") == self.attribute_digest
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
          # = BCrypt::Password.new(remember_digest) == remember_token
          # is_password? is used instead of ==
          # remember_digest = self.remember_digest = a user's remember_digest    
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
        #update_attribute(:activated, true)
        #update_attribute(:activated_at, Time.zone.now)
  end
  
  def send_activation_email
    UserMailer.account_activation(self).deliver_now   #deliver_now is mailing method
  end
  
  
  
  private
  
    def downcase_email
      self.email = email.downcase
    end
    
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
