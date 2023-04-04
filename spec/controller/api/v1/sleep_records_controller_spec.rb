require 'rails_helper'

RSpec.describe Api::V1::SleepRecordsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all sleep records in descending order' do
      sleep_record1 = FactoryBot.create(:sleep_record)
      sleep_record2 = FactoryBot.create(:sleep_record)
      get :index
      expect(assigns(:sleep_records)).to eq([sleep_record2, sleep_record1])
    end
  end

  describe 'POST #clock_in' do
    let(:user) { FactoryBot.create(:user) }

    context 'with valid params' do
      it 'creates a new sleep record' do
        expect do
          post :clock_in, params: { user_id: user.id }
        end.to change(SleepRecord, :count).by(1)
      end

      it 'returns a success response' do
        post :clock_in, params: { user_id: user.id }
        expect(response).to be_successful
      end

      it 'returns a success message' do
        post :clock_in, params: { user_id: user.id }
        expect(JSON.parse(response.body)).to eq({ 'message' => 'Successfully clocked in.' })
      end
    end

    context 'with invalid params' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          post :clock_in
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #friends_sleep_records' do
    let(:user) { FactoryBot.create(:user) }
    let(:friend1) { FactoryBot.create(:user) }
    let(:friend2) { FactoryBot.create(:user) }

    before do
      FactoryBot.create(:user_follow, follower: user, followed: friend1)
      FactoryBot.create(:user_follow, follower: user, followed: friend2)
      FactoryBot.create(:sleep_record, user: friend1, clock_in: 2.days.ago, clock_out: 2.days.ago + 8.hours)
      FactoryBot.create(:sleep_record, user: friend1, clock_in: 1.day.ago, clock_out: 1.day.ago + 8.hours)
      FactoryBot.create(:sleep_record, user: friend2, clock_in: 2.days.ago, clock_out: 2.days.ago + 7.hours)
      FactoryBot.create(:sleep_record, user: friend2, clock_in: 1.day.ago, clock_out: 1.day.ago + 7.hours)
    end

    context 'with valid params' do
      it 'returns a success response' do
        get :friends_sleep_records, params: { user_id: user.id }
        expect(response).to be_successful
      end

      it 'returns only sleep records from friends within the last week' do
        get :friends_sleep_records, params: { user_id: user.id }
        expect(assigns(:sleep_records).count).to eq(4)
      end
    end

    context 'with invalid params' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect do
          get :friends_sleep_records
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
