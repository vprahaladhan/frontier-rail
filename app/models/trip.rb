class Trip < ApplicationRecord
  belongs_to :user
  belongs_to :train
  validates :user_id, presence: true
  validates :train_id, presence: true
  validates :date, presence: true

  scope :my_trips, -> { where(user_id: session[:user_id]) }
end