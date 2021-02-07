module Api
  module V1
    module Admin
      class ExchangesController < ApplicationController
        before_action :authorized

        # GET /exchanges
        # GET /exchanges.json
        def index
          @exchanges = Exchange.where(is_active: true).order(:name)
          render json: @exchanges
        end
      end
    end
  end
end

