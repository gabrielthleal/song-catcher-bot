require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /spotify" do
    it "returns http success" do
      get "/users/spotify"
      expect(response).to have_http_status(:success)
    end
  end

end
