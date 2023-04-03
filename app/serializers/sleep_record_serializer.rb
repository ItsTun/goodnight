class SleepRecordSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :clock_in, :clock_out
end
