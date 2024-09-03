class Log < ApplicationRecord
  belongs_to :challenge

  scope :completed, -> { where(completed_the_day: true) }
end
