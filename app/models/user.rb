class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :username, presence: { message: "is required" }, uniqueness: { message: "is already taken" }
  validates :visibility, inclusion: { in: [true, false] }

  # Associations
  has_many :participations, dependent: :destroy
  has_many :created_challenges, foreign_key: 'creator_id', class_name: 'Challenge', dependent: :nullify
  has_many :joined_challenges, through: :participations, source: :challenge
  has_many :logs, through: :joined_challenges

end
