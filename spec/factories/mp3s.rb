FactoryBot.define do
  factory :mp3 do
    title { Faker::Name.title }
    interpret { Faker::Lorem.word }
    album { Faker::Lorem.word }
    track { Faker::Number.number(10) }
    year { 2011 }
    genre { Faker::Lorem.word }
  end
end