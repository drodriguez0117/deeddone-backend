class User < ApplicationRecord
  validates :email, :presence => true, :uniqueness => true
  validates :password_digest, :presence => true

  has_secure_password
  has_many :listings
end
