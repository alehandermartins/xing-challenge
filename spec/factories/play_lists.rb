FactoryBot.define do
  factory :play_list do
  	user
    name { Faker::Lorem.word }
  end
end
