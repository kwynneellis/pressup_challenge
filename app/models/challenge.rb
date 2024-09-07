class Challenge < ApplicationRecord
  # Associations
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :logs, dependent: :destroy

  enum challenge_type: {
    abstinence: 'Abstinence',
    fixed: 'Fixed',
    incremental: 'Incremental'
  }

  # Scopes for filtering challenges based on their status
  scope :active, -> { where(active: true, archive: false) }
  scope :archived, -> { where(archive: true) }
  scope :public_active, -> { where(public: true, active: true, archive: false) }
  scope :public_visible, -> { where(public: true, archive: false) }

  # Validations
  validates :name, presence: true
  validates :start_date, presence: true
  validates :challenge_type, presence: true

  def end_date
    Date.new(self.start_date.year, 12, 31)
  end

  def cumulative_reps_done
    logs.sum(:reps_in_set)
  end

  def reps_done_on(date)
    logs.where(date_of_set: date).sum(:reps_in_set)
  end

  def reps_done_today
    reps_done_on(Date.today)
  end

  def reps_remaining_on(date)
    target = rep_target_for(date)
    [target - reps_done_on(date), 0].max
  end

  def rep_target_today
    rep_target_for(Date.today)
  end

  def rep_target_for(date)
    # Calculate the number of days since the challenge started
    days_since_start = (date - self.start_date).to_i + 1
    # The number of reps required for that date
    days_since_start
  end

  def cumulative_target_to_date
    return 0 if start_date.nil?

    days_since_start = (Date.today - self.start_date).to_i + 1
    (days_since_start * (days_since_start + 1)) / 2
  end
end
