require 'rails_helper'

RSpec.describe User, type: :model do
  context 'creation' do
    subject { FactoryBot.build(:user) }
    it { should be_valid }
  end

  context 'validation' do
    subject { FactoryBot.build(:user) }

    it { should fail_with_null(:email) }
    it { should fail_with_null(:password) }
  end
end
