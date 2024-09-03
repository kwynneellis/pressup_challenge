class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :username, presence: { message: "is required" }, uniqueness: { message: "is already taken" }
  validates :visibility, inclusion: { in: [true, false] }

  # Associations
  has_many :challenges, dependent: :destroy
  has_many :logs, through: :challenges

  # def end_date
  #   Date.new(self.start_date.year, 12, 31)
  # end

  # def calculate_total_press_ups_done
  #   total = logs.sum(:reps_in_set)
  #   update(total_press_ups: total)
  # end

  # def press_ups_done_on(date)
  #   logs.where(date_of_set: date).sum(:reps_in_set)
  # end

  # def press_ups_done_today
  #   press_ups_done_on(Date.today)
  # end

  # def press_ups_remaining_on(date)
  #   target = press_up_target_for(date)
  #   [target - press_ups_done_on(date), 0].max
  # end

  # def press_up_target_today
  #   press_up_target_for(Date.today)
  # end

  # def press_up_target_for(date)
  #   # Calculate the number of days since the challenge started
  #   days_since_start = (date - start_date).to_i + 1
  #   # The number of press-ups required for that date
  #   days_since_start
  # end

  # def cumulative_press_up_target_to_date
  #   return 0 if start_date.nil?

  #   days_since_start = (Date.today - start_date).to_i + 1
  #   (days_since_start * (days_since_start + 1)) / 2
  # end
end
