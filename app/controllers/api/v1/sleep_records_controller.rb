class Api::V1::SleepRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token

  api :GET, '/sleep_records', 'Get sleep records'
  description 'Get sleep records ordered by created time'

  def index
    @sleep_records = Rails.cache.fetch(SleepRecord.all.cache_key) do
      SleepRecord.order(created_at: :desc)
    end
    render json: @sleep_records, each_serializer: SleepRecordSerializer
  end

  api :POST, '/clock_in', 'Clock In Operation'
  description 'Create clock in for user'
  param :user_id, Integer, required: true

  def clock_in
    user = User.find(params[:user_id])
    sleep_record = user.sleep_records.new(clock_in: Time.now)
    if sleep_record.save
      render json: { message: 'Successfully clocked in.' }
    else
      render json: { message: 'Failed clocking in.' }
    end
  end

  api :GET, '/friends_sleep_records', 'Get sleep records of friends'
  description 'Get sleep records of friends over the past week ordered by the length of their sleep.'
  param :user_id, Integer, required: true

  def friends_sleep_records
    @cache_key ||= begin
      friends = User.find(params[:user_id]).followed_users
      [friends.cache_key, 'sleep_records'].join('/')
    end
    @sleep_records = Rails.cache.fetch(@cache_key) do
      SleepRecord.where(user_id: friends.ids)
                 .where('clock_in >= ?', 1.week.ago)
                 .order(Arel.sql('clock_out - clock_in DESC'))
    end
    render json: @sleep_records, each_serializer: SleepRecordSerializer
  end
end
