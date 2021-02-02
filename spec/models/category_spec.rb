require 'rails_helper'

RSpec.describe Category, type: :model do
  context 'creation' do
    subject { FactoryBot.build(:category) }
    it { should be_valid }
  end

  context 'validation' do
    subject { FactoryBot.build(:category) }

    it 'is invalid when category name is not unique' do
      FactoryBot.create(:category, name: 'cats')
      subject = FactoryBot.build(:category, name: 'cats')

      expect(subject).to_not be_valid
      expect(subject.errors.count).to eq 1
      expect(subject.errors[:name][0]).to eq('has already been taken')
    end
  end

end