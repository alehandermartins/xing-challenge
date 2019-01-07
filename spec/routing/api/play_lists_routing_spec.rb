require "rails_helper"

RSpec.describe Api::PlayListsController, type: :routing do
  describe "routing" do

    it 'routes to playlist #index' do
      expect(:get => '/api/play_lists').to route_to(controller: 'api/play_lists', action: "index")
    end

    it 'routes to playlist #show' do
      expect(:get => '/api/play_lists/2').to route_to(controller: 'api/play_lists', action: "show", id: '2')
    end

    it 'routes to playlist #create' do
      expect(:post => '/api/play_lists').to route_to(controller: 'api/play_lists', action: "create")
    end

    it 'routes to playlist #update via PUT' do
      expect(:put => '/api/play_lists/1').to route_to(controller: 'api/play_lists', action: "update", id: '1')
    end

    it 'routes to playlist #update via PATCH' do
      expect(:patch => '/api/play_lists/1').to route_to(controller: 'api/play_lists', action: "update", id: '1')
    end

    it 'routes to playlist #destroy' do
      expect(:delete => '/api/play_lists/1').to route_to(controller: 'api/play_lists', action: "destroy", id: '1')
    end

    it 'routes to playlist #add_mp3' do
      expect(:post => '/api/play_lists/1/add_mp3').to route_to(controller: 'api/play_lists', action: "add_mp3", id: '1')
    end

    it 'routes to playlist #destroy' do
      expect(:post => '/api/play_lists/1/remove_mp3').to route_to(controller: 'api/play_lists', action: "remove_mp3", id: '1')
    end
  end
end