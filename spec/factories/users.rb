FactoryGirl.define do
  factory :user do
    email FFaker::Internet.email
    password FFaker::Lorem.characters(16)

    factory :confirmed_user do
      confirmed_at 1.day.ago
    end
  end
end
