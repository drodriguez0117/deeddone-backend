class Listing < ApplicationRecord
  validates :title, :presence => true
  validates :description, :presence => true
  validates :listing_type_id, :presence => true

  has_one_attached :image
  # check guides for validation of non-nullable properties
  # validates
end
