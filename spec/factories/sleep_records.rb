FactoryBot.define do
  factory :sleep_record do
    user
    clock_in { Faker::Time.between(from: 2.days.ago, to: Time.now) }
    clock_out { Faker::Time.between(from: clock_in, to: Time.now) }
  end
end
