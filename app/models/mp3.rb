class Mp3 < ApplicationRecord
  # ==== Associations ==============================================
  has_and_belongs_to_many :play_lists
  # ==== Validations ===============================================
  validates :title, :interpret, :album, :track, presence: true
end