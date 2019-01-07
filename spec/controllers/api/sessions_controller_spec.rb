require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do

  let(:user) { create(:user) }

  before(:each) {
    request.headers['HTTP_ACCEPT'] = "application/json"
  }

  describe "login" do

    it "returns jwt valid token" do
      post :login, params: {email: user.email, password: user.password}
      expect(response).to have_http_status(:ok)
      token = JSON.parse(response.body)['jwtToken']
      expect { JWT.decode(token, 'jwtSecret') }.to_not raise_error
    end

    it "returns unauthorized if invalid email" do
      post :login, params: {email: "invalid_email", password: user.password}
      expect(response).to have_http_status(:unauthorized)
    end

    it "returns unauthorized if invalid email" do
      post :login, params: {email: user.email, password: "invalid_password"}
      expect(response).to have_http_status(:unauthorized)
    end
  end
end