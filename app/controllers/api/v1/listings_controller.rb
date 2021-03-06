# frozen_string_literal: true
module Api
  module V1
    class ListingsController < ApplicationController
      skip_before_action :authorized

      # GET /listings
      # GET /listings.json
      def index
        @listings = Listing.where("expires_at <= ?", (Date.today + 30.days).to_s)
                           .where(is_active: true)
                           .with_attached_images

        render json: @listings
      end

      # GET /listings/1
      # GET /listings/1.json
      def show
        #logger.debug "user_id: #{params[:id]}"
        @listing = Listing.where(id: params[:id])
        render json: @listing
      end

      def search
        @listings = Listing.search_active params[:qry]
        logger.debug "Listings: #{@listings}"
        render json: @listings, status: :ok
      end
    end
  end
end