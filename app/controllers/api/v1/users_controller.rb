class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def follow
    follower = User.find(params[:follower_id])
    followed = User.find(params[:followed_id])

    follower.follow(followed)
    render json: { message: 'Successfully followed user' }
  end

  def unfollow
    follower = User.find(params[:follower_id])
    followed = User.find(params[:followed_id])
    follower.unfollow(followed)
    render json: { message: 'Successfully unfollowed user' }
  end
end
