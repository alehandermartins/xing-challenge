require "rails_helper"

RSpec.describe Api::UsersController, type: :routing do
  describe "routing" do

    it 'routes to #index' do
      expect(:get => '/api/users').to route_to(controller: 'api/users', action: "index")
    end

    it 'routes to #show' do
      expect(:get => '/api/users/1').to route_to(controller: 'api/users', action: "show", id: '1')
    end

    it 'routes to #create' do
      expect(:post => '/api/users').to route_to(controller: 'api/users', action: "create")
    end

    it 'routes to #update via PUT' do
      expect(:put => '/api/users/1').to route_to(controller: 'api/users', action: "update", id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(:patch => '/api/users/1').to route_to(controller: 'api/users', action: "update", id: '1')
    end

    it 'routes to #destroy' do
      expect(:delete => '/api/users/1').to route_to(controller: 'api/users', action: "destroy", id: '1')
    end
  end
end
