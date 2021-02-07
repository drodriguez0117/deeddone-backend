module Api
  module V1
    module Admin
      class CategoriesController < ApplicationController
        before_action :authorized

        # GET /categories
        # GET /categories.json
        def index
          @categories = Category.where(is_active: true).order(:name)
          render json: @categories
        end
      end
    end
  end
end
