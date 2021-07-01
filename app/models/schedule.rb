class Schedule < ApplicationRecord
  belongs_to :train
  validates :train_id, presence: true
  validates :date, presence: true

  # scope :trains_with_vacancies_by_date, -> (date) { where(date: date) }
end