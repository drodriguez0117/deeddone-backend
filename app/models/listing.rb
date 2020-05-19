class Listing < ApplicationRecord
  validates :title, :presence => true
  validates :description, :presence => true
  validates :listing_type_id, :presence => true

  has_many_attached :images
  # check guides for validation of non-nullable properties
  # validates
end
