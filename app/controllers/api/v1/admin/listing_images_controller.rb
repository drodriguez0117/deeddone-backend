module Api
  module V1
    module Admin
      class ListingImagesController < ApplicationController
        before_action :authorized
        before_action :set_listing

        def create
          if @listing.images.attach(params[:images])
            render json: @listing, status: :ok, location: admin_listing_url(@listing)
          else
            render json: @listing.errors, status: :unprocessable_entity
          end
        end

        def destroy
          @image_url = params[:id]

          unless @image_url.include? '/'
            render json: 'record not found', status: :unprocessable_entity
          end

          blob = ActiveStorage::Blob.find_signed(blob_from_url)

          unless blob
            render json: 'record not found', status: :unprocessable_entity
          end

          if @listing.images.find(blob[:id]).purge
            render json: @listing, status: :ok, location: admin_listing_url(@listing)
          else
            render json: @listing.errors, status: :unprocessable_entity
          end
        end

        private

        # usual fuckery...do better - hardcoded start position
        # is not going to fly
        def blob_from_url
          filename = @image_url.length - @image_url.rindex('/')
          trim_url = @image_url[28, @image_url.length - filename]
          trim_url[0, trim_url.length - filename]
        end

        # Use callbacks to share common setup or constraints between actions.
        def set_listing
          @listing = logged_in_user.listings.find(params[:listing_id])
        end

        # Only allow a list of trusted parameters through.
        def listing_images_params
          params.permit(:id, images: [])
        end
      end
    end
  end
end
