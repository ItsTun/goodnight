class Api::V1::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def follow
    follower.follow(followed)
    render_success('followed')
  end

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
