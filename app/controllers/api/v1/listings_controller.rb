require 'pp'

module Api
  module V1
    class ListingsController < ApplicationController
      before_action :set_listing, only: %i[show, create, update, destroy]

      # GET /listings
      # GET /listings.json
      def index
        @listings = Listing.all
        render json: @listings
      end

      # GET /listings/1
      # GET /listings/1.json
      def show
        render json: @listing
      end

      # POST /listings
      # POST /listings.json
      def create
        @listing = Listing.new(listing_params)
        #@listing.image.attach(params.dig(:listing, :image))

        if @listing.save
          render json: @listing, status: :created
          #render :show, status: :created, location: api_v1_listing_url(@listing)
          #redirect_to api_v1_listing_url @listing
        else
          render json: @listing.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /listings/1
      # PATCH/PUT /listings/1.json
      def update

        @listing = Listing.find(params[:id])

        if @listing.image.attached?
          @listing.image.purge_later
          @listing.image.attach(params[:image])
        end

        if @listing.update(listing_params)
          render json: @listing, status: :ok, location: api_v1_listing_url(@listing)
          #render :show, status: :ok, location: @listing
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
        @listing = Listing.find(params[:id])
          #@listing = Listing.with_attached_images.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def listing_params
        params.require(:listing).permit(:title, :description, :listing_type_id, :image)
      end
    end
  end
end