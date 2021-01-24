# frozen_string_literal: true
module Api
  module V1
    class ListingsController < ApplicationController

      # GET /listings
      # GET /listings.json
      def index
        @listings = Listing.all.with_attached_images
        render json: @listings
      end

      # GET /listings/1
      # GET /listings/1.json
      def show
        #logger.debug "user_id: #{params[:id]}"
        @listing = Listing.where(id: params[:id])
        render json: @listing
      end
    end
  end
end