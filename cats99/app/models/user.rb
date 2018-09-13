# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :password_digest, presence: true
  before_validation :ensure_session_token
  
  attr_reader :password
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end 
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save! 
    self.session_token
  end 
  
  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end 
  
  def is_password?(pw)
    BCrypt::Password.new(password_digest).is_password?(pw)
  end 
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name:user_name)  
    if user 
      return user if user.is_password?(password) 
    end
    nil
  end
end
