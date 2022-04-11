require 'rails_helper'

RSpec.describe "Sites", type: :request do
  describe "GET /encode" do
    it "returns http success" do
      get "/site/encode"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /decode" do
    it "returns http success" do
      get "/site/decode"
      expect(response).to have_http_status(:success)
    end
  end

end
