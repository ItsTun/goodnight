class User < ApplicationRecord
  # Validations
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }, uniqueness: true
  validate :name_cannot_contain_numbers

  # Associations
  has_many :sleep_records
  has_many :user_follows, foreign_key: :follower_id, dependent: :destroy
  has_many :followed_users, through: :user_follows, source: :followed

  def follow(user_to_follow)
    user_follows.create(followed: user_to_follow)
  end

  def unfollow(user_to_unfollow)
    user_follows.find_by(followed_id: user_to_unfollow.id).destroy
  end

  def following?(user)
    followed_users.include?(user)
  end

  private

  def name_cannot_contain_numbers
    errors.add(:name, 'cannot contain numbers') if name && name.match(/\d/)
  end
end
