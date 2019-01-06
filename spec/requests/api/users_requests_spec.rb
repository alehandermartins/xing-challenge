require 'rails_helper'

RSpec.describe 'Users', type: :request do

  let(:user)  { create(:user) }

  before(:each) do
    post '/api/login', params: {email: user.email, password: user.password}
    token = JSON.parse(response.body)['jwtToken']
    @headers = {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json', 'AUTHORIZATION' => 'Bearer ' + token}
  end

  def serialized_record record
    UserSerializer.new(record).serializable_hash.with_indifferent_access
  end

  describe 'GET /api/users' do
    it 'returns array of users' do
      new_user = create(:user)
      get '/api/users', headers: @headers
      result = JSON.parse(response.body)['users']
      expect(result).to eq [serialized_record(user), serialized_record(new_user)]
    end
  end

  describe 'GET /api/users/:id' do
    it 'returns user' do
      get "/api/users/#{user.id}", headers: @headers
      result = JSON.parse(response.body)['user']
      expect(result).to eq serialized_record(user)
    end
  end

  describe 'POST /api/users/' do
    let(:valid_attributes) {{
      first_name: 'first_name',
      last_name: 'last_name',
      user_name: 'user_name',
      email: 'user@email.com',
      password: 'password'
    }}

    before(:each) do
      post '/api/users', params: {user: valid_attributes}
    end

    it 'renders a JSON response with the new user' do
      result = JSON.parse(response.body)['user']
      expect(result["first_name"]).to eq(valid_attributes[:first_name])
      expect(result["last_name"]).to eq(valid_attributes[:last_name])
      expect(result["user_name"]).to eq(valid_attributes[:user_name])
      expect(result["email"]).to eq(valid_attributes[:email])
    end

    it 'creates an object with the provided params' do
      created_user = User.last
      expect(created_user.first_name).to eq(valid_attributes[:first_name])
      expect(created_user.last_name).to eq(valid_attributes[:last_name])
      expect(created_user.user_name).to eq(valid_attributes[:user_name])
      expect(created_user.email).to eq(valid_attributes[:email])
    end
  end

  describe 'PUT /api/users/:id' do
    before(:each) do
      params = {user: {first_name: "new name", password: "password"}}.to_json
      put "/api/users/#{user.id}", params: params, headers: @headers
    end

    it 'renders a JSON response with the updated user' do
      result = JSON.parse(response.body)['user']
      expect(result["first_name"]).to eq("new name")
    end

    it 'updates user' do
      updated_user = User.find(user.id)
      expect(updated_user.first_name).to eq("new name")
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the record' do
      delete "/api/users/#{user.id}", headers: @headers
      expect{User.find(user.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
