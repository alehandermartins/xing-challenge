require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do

    it 'routes to #index' do
      expect(:get => '/').to route_to(controller: 'users', action: "index")
    end
  end
end
