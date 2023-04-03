require 'rails_helper'

RSpec.describe UserFollow, type: :model do
  let(:follower) { FactoryBot.create(:user) }
  let(:followed) { FactoryBot.create(:user) }

  describe 'validations' do
    context 'when follower_id and followed_id are valid' do
      it 'is valid' do
        user_follow = described_class.new(follower: follower, followed: followed)
        expect(user_follow).to be_valid
      end
    end

    context 'when follower_id is missing' do
      it 'is invalid' do
        user_follow = described_class.new(followed: followed)
        expect(user_follow).to be_invalid
        expect(user_follow.errors[:follower_id]).to include("can't be blank")
      end
    end

    context 'when followed_id is missing' do
      it 'is invalid' do
        user_follow = described_class.new(follower: follower)
        expect(user_follow).to be_invalid
        expect(user_follow.errors[:followed_id]).to include("can't be blank")
      end
    end

    context 'when follower_id and followed_id are the same' do
      it 'is invalid' do
        user_follow = described_class.new(follower: follower, followed: follower)
        expect(user_follow).to be_invalid
        expect(user_follow.errors[:followed_id]).to include("can't be the same as follower_id")
      end
    end

    context 'when follower_id is not an integer' do
      it 'is invalid' do
        user_follow = described_class.new(follower_id: 'string', followed: followed)
        expect(user_follow).to be_invalid
        expect(user_follow.errors[:follower_id]).to include('is not a number')
      end
    end

    context 'when followed_id is not an integer' do
      it 'is invalid' do
        user_follow = described_class.new(follower: follower, followed_id: 'string')
        expect(user_follow).to be_invalid
        expect(user_follow.errors[:followed_id]).to include('is not a number')
      end
    end
  end
end
