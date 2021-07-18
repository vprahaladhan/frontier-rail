class Trip < ApplicationRecord
  belongs_to :user
  belongs_to :train

  validates :user_id, presence: true
  validates :train_id, presence: true
  validates :date, presence: true

  validate :date_cannot_be_in_the_past

  def date_cannot_be_in_the_past
    puts "DATE > #{date}"
    if date <= Date.today
      errors.add(:date, "Trip date has to be at least 1 day from today!")
    end
  end

  scope :user_trips, ->(user_id) { where(user_id: user_id) }
  scope :train_trips, ->(train_id) { where(train_id: train_id) }
end
