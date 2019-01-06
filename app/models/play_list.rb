class PlayList < ApplicationRecord
  # ==== Associations ==============================================
  belongs_to :user
  has_and_belongs_to_many :mp3s
  # ==== Validations ===============================================
  validates :name, presence: true
end