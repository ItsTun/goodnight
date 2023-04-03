class UserFollow < ApplicationRecord
  # Validations
  validates :follower_id, presence: true, numericality: { only_integer: true }
  validates :followed_id, presence: true, numericality: { only_integer: true }
  validate :cannot_follow_self

  # Associations
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  private

  def cannot_follow_self
    errors.add(:followed_id, "can't be the same as follower_id") if follower_id == followed_id
  end
end
