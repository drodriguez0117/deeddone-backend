require 'rails_helper'

RSpec.describe Exchange, type: :model do
  context 'creation' do
    subject { FactoryBot.build(:exchange) }
    it { should be_valid }
  end

  context 'validation' do
    subject { FactoryBot.build(:exchange) }

    it 'is invalid when category name is not unique' do
      FactoryBot.create(:exchange, name: 'cats')
      subject = FactoryBot.build(:exchange, name: 'cats')

      expect(subject).to_not be_valid
      expect(subject.errors.count).to eq 1
      expect(subject.errors[:name][0]).to eq('has already been taken')
    end
  end
end
