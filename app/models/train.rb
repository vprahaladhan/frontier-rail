class Train < ApplicationRecord
  has_many :trips
  has_many :users, through: :trips
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true
end