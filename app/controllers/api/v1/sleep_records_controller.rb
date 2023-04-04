class Api::V1::SleepRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user, only: [:clock_in, :friends_sleep_records]

  def index
    @sleep_records = SleepRecord.order(created_at: :desc)
    Rails.cache.write(SleepRecord.all.cache_key, @sleep_records) if stale?(@sleep_records)
    render json: @sleep_records, each_serializer: SleepRecordSerializer
  end

  def clock_in
    sleep_record = @user.sleep_records.new(clock_in: Time.now)
    if sleep_record.save
      render json: { message: 'Successfully clocked in.' }
    else
      render json: { message: 'Failed clocking in.' }
    end
  end

  def friends_sleep_records
    friends = @user.followed_users
    cache_key = [friends.cache_key, 'sleep_records', 1.week.ago.to_i].join('/')
    @sleep_records = Rails.cache.fetch(cache_key) do
      SleepRecord.where(user_id: friends.select(:id))
                 .where('clock_in >= ?', 1.week.ago)
                 .order(Arel.sql('clock_out - clock_in DESC'))
    end
    render json: @sleep_records, each_serializer: SleepRecordSerializer
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
