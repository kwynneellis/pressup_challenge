class Log < ApplicationRecord
  belongs_to :challenge
  has_one :user, through: :challenge

  scope :completed, -> { where(completed_the_day: true) }
end
