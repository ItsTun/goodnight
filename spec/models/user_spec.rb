require 'rails_helper'


RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a name less than 3 characters' do
      subject.name = 'Jo'
      expect(subject).to_not be_valid
    end

    it 'is not valid with a name more than 50 characters' do
      subject.name = 'a' * 51
      expect(subject).to_not be_valid
    end

    it 'is not valid with a name containing numbers' do
      subject.name = 'John Doe 123'
      expect(subject).to_not be_valid
    end

    it 'is not valid with a duplicate name' do
      subject.update(name: 'Joh Doe')
      new_user = User.new(name: 'Joh Doe')
      expect(new_user).to_not be_valid
    end
  end

  describe 'associations' do
  end


  describe '#follow' do
    let(:user_to_follow) { FactoryBot.create :user }

    it 'creates a new user follow record' do
      expect { subject.follow(user_to_follow) }.to change { UserFollow.count }.by(1)
    end

    it 'follows the specified user' do
      subject.follow(user_to_follow)
      expect(subject.following?(user_to_follow)).to be_truthy
    end
  end

  describe '#unfollow' do
    let(:user_to_unfollow) { FactoryBot.create :user }
    let!(:user_follow) { FactoryBot.create(:user_follow, follower: subject, followed: user_to_unfollow) }

    it 'destroys the corresponding user follow record' do
      expect { subject.unfollow(user_to_unfollow) }.to change { UserFollow.count }.by(-1)
    end

    it 'unfollows the specified user' do
      subject.unfollow(user_to_unfollow)
      expect(subject.following?(user_to_unfollow)).to be_falsey
    end
  end

  describe '#following?' do
    let(:user_to_follow) { FactoryBot.create :user }

    it 'returns true if the user is following the specified user' do
      subject.follow(user_to_follow)
      expect(subject.following?(user_to_follow)).to be_truthy
    end

    it 'returns false if the user is not following the specified user' do
      expect(subject.following?(user_to_follow)).to be_falsey
    end
  end
end
