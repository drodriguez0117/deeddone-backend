require "rails_helper"

RSpec.describe Api::V1::Admin::ExchangesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "admin/exchanges").to route_to("api/v1/admin/exchanges#index")
    end
  end
end
