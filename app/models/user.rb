class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :username, presence: { message: "is required" }, uniqueness: { message: "is already taken" }
  validates :visibility, inclusion: { in: [true, false] }
  validates :reminder_email_opt_in, inclusion: { in: [true, false] }

  # Associations
  has_many :participations, dependent: :destroy
  has_many :created_challenges, foreign_key: 'creator_id', class_name: 'Challenge', dependent: :nullify
  has_many :joined_challenges, through: :participations, source: :challenge
  has_many :logs, through: :joined_challenges

  scope :opted_in, -> { where(reminder_email_opt_in: true) }

  belongs_to :primary_challenge, class_name: "Challenge", optional: true

  def participating_in?(challenge)
    joined_challenges.exists?(challenge.id)
  end

  def set_primary_challenge(challenge)
    update(primary_challenge: challenge)
  end

  def remove_primary_challenge
    self.primary_challenge = nil
    update(primary_challenge: default_primary_challenge)
  end

  def default_primary_challenge
    joined_challenges.active.order(:created_at).first
  end

  def self.send_daily_target_reminders
    opted_in.each do |user|
      if user.joined_challenges.with_unmet_targets_for(user).any?
        UserMailer.with(user: user).daily_target_reminder.deliver_later
      end
    end
  end
end
