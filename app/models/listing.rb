class Listing < ApplicationRecord
  validates :title, :presence => true
  validates :listing_type_id, :presence => true

  belongs_to :user
  has_many_attached :images
end
