class SleepRecord < ApplicationRecord
  # Validations
  validates :user_id, presence: true
  validates :clock_in, presence: true
  validate :clock_in_cannot_be_later_than_clock_out

  # Associations
  belongs_to :user

  private

  def clock_in_cannot_be_later_than_clock_out
    errors.add(:clock_in, 'cannot be later than clock out') if clock_in && clock_out && clock_in > clock_out
  end
end
