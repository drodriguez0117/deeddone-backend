module Api
  module V1
    class ListingsController < ApplicationController
      before_action :set_listing, only: [:show, :update, :destroy]

      # GET /listings
      # GET /listings.json
      def index
        @listings = Listing.all
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

        if @listing.save
          render :show, status: :created, location: @listing
        else
          render json: @listing.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /listings/1
      # PATCH/PUT /listings/1.json
      def update
        if @listing.update(listing_params)
          render :show, status: :ok, location: @listing
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
      end

      # Only allow a list of trusted parameters through.
      def listing_params
        params.require(:listing).permit(:title, :description, :listing_type_id, :media_id)
      end
    end
  end
end