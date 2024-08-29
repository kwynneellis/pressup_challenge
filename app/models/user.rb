class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :username, presence: { message: "is required" }, uniqueness: { message: "is already taken" }
  validates :start_date, presence: { message: "is required" }

  # Associations
  has_many :logs, dependent: :destroy

  def end_date
    Date.new(self.start_date.year, 12, 31)
  end
end
