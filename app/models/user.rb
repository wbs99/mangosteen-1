class User < ApplicationRecord
  validates :email, presence: true
  has_many :tags

  def generate_jwt
    payload = { user_id: self.id, exp: (Time.current + 1.hours).to_i }
    JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
  end

  def generate_auth_header
    {Authorization: "Bearer #{self.generate_jwt}"}
  end

  def generate_refresh_jwt
    payload = { user_id: self.id, exp: (Time.current + 7.days).to_i }
    JWT.encode payload, Rails.application.credentials.hmac_secret, 'HS256'
  end

  def generate_refresh_auth_header
    {Authorization: "Bearer #{self.generate_refresh_jwt}"}
  end
end