require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  subject { FactoryBot.create(:sleep_record) }

  # Validations

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is invalid with no user_id' do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it 'is invalid with no clock in' do
    subject.clock_in = nil
    expect(subject).to_not be_valid
  end

  context 'when clock in is later than clock out' do
    it 'is invalid' do
      subject.clock_in = Time.now
      subject.clock_out = 1.hour.ago
      expect(subject).to_not be_valid
      expect(subject.errors[:clock_in]).to include('cannot be later than clock out')
    end
  end

  context 'when clock in is earlier than clock out' do
    it 'is valid' do
      subject.clock_in = 1.hour.ago
      subject.clock_out = Time.now
      expect(subject).to be_valid
    end
  end
end
