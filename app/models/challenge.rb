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
  scope :with_unmet_targets_for, ->(user) {
    select { |challenge| challenge.reps_done_today(user) < challenge.rep_target_today }
  }

  before_save :set_end_date
  before_save :set_active_and_archive

  # Validations
  validates :name, presence: true
  validates :start_date, presence: true
  validates :challenge_type, presence: true


  def cumulative_reps_done(user)
    logs.where(user: user).sum(:reps_in_set)
  end

  def reps_done_on(date, user)
    logs.where(date_of_set: date, user: user).sum(:reps_in_set)
  end

  def reps_done_today(user)
    reps_done_on(Date.today, user)
  end

  def reps_remaining_on(date, user)
    target = rep_target_for(date)
    [target - reps_done_on(date, user), 0].max
  end

  def rep_target_today
    rep_target_for(Date.today)
  end

  def rep_target_for(date)
    case self.challenge_type
    when "abstinence"
      daily_abstinence_target
    when "fixed"
      daily_fixed_target
    when "incremental"
      daily_incremental_target(date)
    end
  end

  def cumulative_target_to_date
    case self.challenge_type
    when "abstinence"
      today_days_since_start
    when "fixed"
      today_days_since_start * daily_fixed_target
    when "incremental"
      cumulative_incremental_target
    end
  end

  def total_target_of_challenge
    case self.challenge_type
    when "abstinence"
      days_in_challenge
    when "fixed"
      days_in_challenge * daily_fixed_target
    when "incremental"
      total_incremental_target
    end
  end

  def today_days_since_start
    days_since_start(Date.today)
  end

  def days_in_challenge
    days_since_start(self.end_date)
  end

  def set_active_and_archive
    if start_date.present?
      self.active = start_date <= Date.today && end_date >= Date.today
    end
    self.archive = false if archive.nil?
  end

  private

  def days_since_start(date)
    return 0 if start_date.nil?
    (date - self.start_date).to_i + 1
  end

  def daily_abstinence_target
    1 # effectively true or false. 1 being they completed the day
  end

  def daily_fixed_target
    self.fixed_rep_target || 1
  end

  def daily_incremental_target(date)
    days_since_start_date = days_since_start(date)
    if self.starting_volume.present? && self.starting_volume > 1
      days_since_start_date += self.starting_volume - 1
    end

    days_since_start_date
  end

  def cumulative_incremental_target
    cumulative_target = (today_days_since_start * (today_days_since_start + 1)) / 2
    if self.starting_volume.present? && self.starting_volume > 1
      cumulative_target += (today_days_since_start * (self.starting_volume - 1))
    end

    cumulative_target
  end

  def total_incremental_target
    total_accumulation = (days_in_challenge * (days_in_challenge + 1)) / 2
    if self.starting_volume.present? && self.starting_volume > 1
      total_accumulation += (days_in_challenge * (self.starting_volume - 1))
    end

    total_accumulation
  end

  def set_end_date
    self.end_date || Date.new(self.start_date.year, 12, 31)
  end
end
