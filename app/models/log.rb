class Log < ApplicationRecord
  belongs_to :challenge
  belongs_to :user

  validates :user_id, presence: true

  scope :completed, -> { where(completed_the_day: true) }
end
