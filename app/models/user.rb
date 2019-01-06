class User < ApplicationRecord
  # ==== Associations ==============================================
  has_many :play_lists
  has_many :mp3s, through: :play_lists
  # ==== Validations ===============================================
  validates :first_name, :last_name, :user_name, :email, :password, presence: true

  devise :database_authenticatable
end
