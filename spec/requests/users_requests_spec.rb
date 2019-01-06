require 'rails_helper'

RSpec.describe 'Users', type: :request do

  describe 'GET /' do
    it 'displays array of users' do
      user = create(:user)
      new_user = create(:user)
      get '/'
      expect(response.body).to include(user.first_name)
      expect(response.body).to include(new_user.first_name)
    end
  end
end
