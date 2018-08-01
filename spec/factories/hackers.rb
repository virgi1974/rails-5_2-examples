FactoryBot.define do
  factory :hacker do
    email FFaker::Internet.email
    password FFaker::Internet.password
    confirmed_at Time.now
  end

end