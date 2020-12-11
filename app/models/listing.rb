# frozen_string_literal: true
class Listing < ApplicationRecord
  validates_presence_of :title, :listing_type

  validates_length_of :title, maximum: 30
  validates_length_of :description, maximum: 200

  validate :validate_listing_type
  
  belongs_to :user

  has_many_attached :images

  def images_or_default
    if images.count > 0
      images.map do |img|
        { image: Rails.application.routes.url_helpers.rails_blob_url(img, only_path: true)}
      end
    else
      # tests on  model
      [{image: ActionController::Base.helpers.asset_url('listing.listing_type.default_image', only_path: true)}]
    end
  end

  def as_json(options={})
    {
        id: id,
        title: title,
        description: description,
        listing_type: listing_type,
        is_active: is_active,
        images: images_or_default
    }
  end

  private

  def validate_listing_type
    #debugger
    unless listing_type == 'offering' || listing_type == 'request'
      errors.add(:listing_type, ' is invalid')
    end
  end

end
