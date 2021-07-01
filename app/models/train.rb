class Train < ApplicationRecord
  has_many :trips
  has_many :users, through: :trips
  has_many :schedules

  validate :to_same_as_from
  validates :name, presence: true, uniqueness: true
  validates :from, presence: true
  validates :to, presence: true
  validates :capacity, presence: true

  def to_same_as_from
    if from.strip.downcase == to.strip.downcase
      errors.add(:to, "Origin and destination stations can't be the same!")
    end
  end
end