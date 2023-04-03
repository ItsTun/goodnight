class Api::V1::SleepRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @sleep_records = Rails.cache.fetch(SleepRecord.all.cache_key) do
      SleepRecord.order(created_at: :desc)
    end
    render json: @sleep_records
  end

  def clock_in
    user = User.find(params[:user_id])
    sleep_record = user.sleep_records.new(clock_in: Time.now)
    if sleep_record.save
      render json: { message: 'Successfully clocked in.' }
    else
      render json: { message: 'Failed clocking in.' }
    end
  end

  def friends_sleep_records
    friends = User.find(params[:user_id]).followed_users
    cache_key = [friends.cache_key, 'sleep_records'].join('/')
    @sleep_records = Rails.cache.fetch(cache_key) do
      SleepRecord.where(user_id: friends.ids)
                 .where('clock_in >= ?', 1.week.ago)
                 .order(Arel.sql('clock_out - clock_in DESC'))
    end
    render json: @sleep_records
  end
end
