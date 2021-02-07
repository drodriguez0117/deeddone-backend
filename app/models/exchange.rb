class Exchange < ApplicationRecord
  validates :name, :presence => true, :uniqueness => true
  has_many :listings
end
