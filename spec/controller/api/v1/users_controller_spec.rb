require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  let(:follower) { FactoryBot.create :user }
  let(:followed) { FactoryBot.create :user }

  describe 'POST #follow' do
    it 'follows the specified user' do
      post :follow, params: { follower_id: follower.id, followed_id: followed.id }
      expect(response).to have_http_status(:success)
      expect(follower.following?(followed)).to be_truthy
    end

    it 'returns a success message' do
      post :follow, params: { follower_id: follower.id, followed_id: followed.id }
      expect(response.body).to eq({ message: 'Successfully followed user' }.to_json)
    end
  end

  describe 'POST #unfollow' do
    before { follower.follow(followed) }

    it 'unfollows the specified user' do
      post :unfollow, params: { follower_id: follower.id, followed_id: followed.id }
      expect(response).to have_http_status(:success)
      expect(follower.following?(followed)).to be_falsey
    end

    it 'returns a success message' do
      post :unfollow, params: { follower_id: follower.id, followed_id: followed.id }
      expect(response.body).to eq({ message: 'Successfully unfollowed user' }.to_json)
    end
  end
end
