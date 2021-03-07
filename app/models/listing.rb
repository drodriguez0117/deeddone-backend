# frozen_string_literal: true

class Listing < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates_presence_of :title, :listing_type

  validates_length_of :title, maximum: 30
  validates_length_of :description, maximum: 200

  validate :validate_listing_type

  belongs_to :user
  belongs_to :category
  belongs_to :exchange

  has_many_attached :images

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title,       type: :text,    analyzer: :english
      indexes :description, type: :text,    analyzer: :english
      indexes :is_active,   type: :boolean
    end
  end

  def images_or_default
    if images.count.positive?
      images.map do |img|
        { image: Rails.application.routes.url_helpers.rails_blob_url(img, only_path: true) }
      end
    else
      [{ image: ActionController::Base.helpers.image_url(category.default_image_path, type: :image) }]
    end
  end

  def as_json(_options = {})
    {
      id: id,
      title: title,
      description: description,
      listing_type: listing_type,
      is_active: is_active,
      images: images_or_default,
      category: category,
      exchange: exchange,
      expires_at: expires_at,
      user_id: user.id
    }
  end

  def self.search_active(qry)
    search({
             query: {
               bool: {
                 filter: {
                   term: {
                     is_active: true
                   }
                 },
                 must:
                   {
                     multi_match: {
                       query: qry,
                       fields: %i[title description]
                     }
                   }
                 }
             }
           }).records
  end

  private

  def validate_listing_type
    # debugger
    unless listing_type == 'offering' || listing_type == 'request'
      errors.add(:listing_type, ' is invalid')
    end
  end
end
