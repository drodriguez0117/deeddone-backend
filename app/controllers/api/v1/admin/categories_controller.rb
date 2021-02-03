module Api
  module V1
    module Admin
      class CategoriesController < ApplicationController
        before_action :authorized

        # GET /categories
        # GET /categories.json
        def index
          @categories = Category.all
          render json: @categories
        end
      end
    end
  end
end
