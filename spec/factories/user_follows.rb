FactoryBot.define do
  factory :user_follow do
    association :follower, factory: :user
    association :followed, factory: :user
  end
end
