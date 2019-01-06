class PlayListSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :mp3s
end
