require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  context 'creation' do
    subject { FactoryBot.build(:user) }
    it { should be_valid }
  end

  context 'validation' do
    subject { FactoryBot.build(:user) }

    it { should fail_with_null(:email) }
    it { should fail_with_null(:password) }

    it 'is invalid when email address is not unique' do
      FactoryBot.create(:user, email: 'test@domain.com')
      subject = FactoryBot.build(:user, email: 'test@domain.com')

      expect(subject).to_not be_valid
      expect(subject.errors.count).to eq 1
      expect(subject.errors[:email][0]).to eq('has already been taken')
    end
  end
end
