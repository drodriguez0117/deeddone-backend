module Api
  module V1
    module Admin
      class CategoriesController < ApplicationController
        before_action :authorized

      end
    end
  end
end
