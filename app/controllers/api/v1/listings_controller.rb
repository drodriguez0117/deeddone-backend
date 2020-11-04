# frozen_string_literal: true
module Api
  module V1
    class ListingsController < ApplicationController

      # GET /listings
      # GET /listings.json
      def index
        @listings = Listing.all.with_attached_images

        render json: add_image_to_listing
      end

      # GET /listings/1
      # GET /listings/1.json
      def show
        #logger.debug "user_id: #{params[:id]}"
        @listings = Listing.where(id: params[:id])

        render json: add_image_to_listing
      end

      # move to model
      def add_image_to_listing
        @listings.map { |listing|
          listing.as_json.merge({ images: listing.images.map do |img|
            { image: rails_blob_url(img, only_path: true)} end }) }
      end
    end
  end
end