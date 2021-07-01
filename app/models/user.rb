class User < ApplicationRecord
  has_secure_password
  has_many :trips
  has_many :trains, through: :trips
  has_many :schedules, through: :trains
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :provider }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
end