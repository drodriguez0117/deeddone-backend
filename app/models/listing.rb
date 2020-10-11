# frozen_string_literal: true
class Listing < ApplicationRecord
  validates_presence_of :title, :listing_type

  validate :validate_listing_type

  belongs_to :user

  has_many_attached :images

  private

  def validate_listing_type
    #debugger
    unless listing_type == 'offering' || listing_type == 'request'
      errors.add(:listing_type, ' is invalid')
    end
  end

  def default_image
    # if exists > 0 -> get first image
    # else -> use category and get the default
    #
    # test when not found
  end

end
