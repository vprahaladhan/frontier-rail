class User < ApplicationRecord
  has_secure_password
  has_many :trips
  has_many :trains, through: :trips
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :provider }
end