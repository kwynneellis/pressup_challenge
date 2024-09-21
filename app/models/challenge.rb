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
    days_since_start = (date - self.start_date).to_i + 1
    days_since_start
  end

  def cumulative_target_to_date
    return 0 if start_date.nil?

    days_since_start = (Date.today - self.start_date).to_i + 1
    (days_since_start * (days_since_start + 1)) / 2
  end

  private

  def set_end_date
    self.end_date || Date.new(self.start_date.year, 12, 31)
  end

  def set_active_and_archive
    if start_date.present?
      self.active = start_date <= Date.today && end_date >= Date.today
    end
    self.archive = false if archive.nil?
  end
end
