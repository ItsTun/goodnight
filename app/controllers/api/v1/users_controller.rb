class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  api :GET, '/follow', 'Follow user'
  description 'Following another user'
  param :follower_id, Integer, required: true
  param :followed_id, Integer, required: true

  def follow
    follower.follow(followed)
    render_success('followed')
  end

  api :GET, '/unfollow', 'Unfollow user'
  description 'Unfollowing followed user'
  param :follower_id, Integer, required: true
  param :followed_id, Integer, required: true

  def unfollow
    follower.unfollow(followed)
    render_success('unfollowed')
  end

  private

  def follower
    @follower ||= User.find(params[:follower_id])
  end

  def followed
    @followed ||= User.find(params[:followed_id])
  end

  def render_success(action)
    render json: { message: "Successfully #{action} user" }
  end
end
