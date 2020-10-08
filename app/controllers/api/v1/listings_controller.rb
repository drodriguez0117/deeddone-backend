# frozen_string_literal: true
module Api
  module V1
    class ListingsController < ApplicationController
      before_action :authorize_access_request!, except: %i[show index]
      before_action :set_listing, only: %i[update destroy]

      # GET /listings
      # GET /listings.json
      def index
        @listings = Listing.all.with_attached_images

        render json: add_image_to_listing
        #render json: @listing.images.map do |image|
        #rails_blob_path(image, only_path: true) if object.images.attached?
        #end

        #render json: @listings
      end

      # GET /listings/1
      # GET /listings/1.json
      def show
        # @listings = Listing.find(params[:id])
        logger.debug "user_id: #{params[:id]}"
        @listings = Listing.where(user_id: params[:id])

        render json: add_image_to_listing

          #render json: @listings, status: :ok
      end

      # POST /listings
      # POST /listings.json
      def create
        @listing = current_user.listings.build(listing_params)
        #@listing = Listing.new(listing_params)
        #@listing.user = current_user

        if @listing.save
          render json: @listing, status: :created
        else
          render json: @listing.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /listings/1
      # PATCH/PUT /listings/1.json
      def update

        @listing = Listing.find(params[:id])

        if @listing.images.attached?
          @listing.images.purge_later
          @listing.images.attach(params[:images])
        end

        if @listing.update(listing_params)
          render json: @listing, status: :ok, location: api_v1_listing_url(@listing)
        else
          render json: @listing.errors, status: :unprocessable_entity
        end
      end

      # DELETE /listings/1
      # DELETE /listings/1.json
      def destroy
        @listing.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_listing
        @listing = current_user.listings.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def listing_params
        params.require(:listing).permit(:title, :description, :listing_type, images: [])
      end

      def add_image_to_listing
        @listings.map { |listing|
          listing.as_json.merge({ images: listing.images.map do |img|
            { image: rails_blob_url(img, only_path: true)} end }) }
      end
    end
  end
end