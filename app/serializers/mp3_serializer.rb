class Mp3Serializer < ActiveModel::Serializer
  attributes :id, :title, :interpret, :album, :track, :year, :genre
end
