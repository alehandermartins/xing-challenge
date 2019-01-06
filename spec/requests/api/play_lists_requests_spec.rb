require 'rails_helper'

RSpec.describe 'PlayLists', type: :request do

  let(:play_list) { create(:play_list) }
  let(:user) { play_list.user }

  before(:each) do
    post '/api/login', params: {email: user.email, password: user.password}
    token = JSON.parse(response.body)['jwtToken']
    @headers = {'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json', 'AUTHORIZATION' => 'Bearer ' + token}
  end

  def serialized_record record
    PlayListSerializer.new(record).serializable_hash.with_indifferent_access
  end

  describe 'GET /api/playlists' do
    it 'returns array of playlists' do
      new_playlist = create(:play_list, user: user)
      get '/api/play_lists', headers: @headers
      result = JSON.parse(response.body)['play_lists']
      expect(result).to eq [serialized_record(play_list), serialized_record(new_playlist)]
    end
  end

  describe 'GET /api/play_lists/:id' do
    it 'returns play_list' do
      get "/api/play_lists/#{user.id}", headers: @headers
      result = JSON.parse(response.body)['play_list']
      expect(result).to eq serialized_record(play_list)
    end
  end

  describe 'POST /api/play_lists/' do
    let(:valid_attributes) {{
      name: 'play_list_name'
    }}

    before(:each) do
      post '/api/play_lists', params: {play_list: valid_attributes}
    end

    it 'renders a JSON response with the new play_list' do
      result = JSON.parse(response.body)['play_list']
      expect(result["name"]).to eq(valid_attributes[:name])
    end

    it 'creates an object with the provided params' do
      created_play_list = PlayList.last
      expect(created_play_list.name).to eq(valid_attributes[:name])
    end
  end

  describe 'PUT /api/play_lists/:id' do
    before(:each) do
      params = {play_list: {name: "new name"}}.to_json
      put "/api/play_lists/#{play_list.id}", params: params, headers: @headers
    end

    it 'renders a JSON response with the updated play_list' do
      result = JSON.parse(response.body)['play_list']
      expect(result["name"]).to eq("new name")
    end

    it 'updates user' do
      updated_play_list = PlayList.find(play_list.id)
      expect(updated_play_list.name).to eq("new name")
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the record' do
      delete "/api/play_lists/#{play_list.id}", headers: @headers
      expect{PlayList.find(play_list.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /api/play_lists/:id/add_mp3' do

    let(:mp3) { create(:mp3) }

    it 'adds mp3 to play_list' do
      post "/api/play_lists/#{play_list.id}/add_mp3", params: {mp3: { mp3_id: mp3.id}}
      expect(play_list.mp3s.first).to eq(mp3)
    end
  end

  describe 'POST /api/play_lists/:id/remove_mp3' do

    let(:mp3) { create(:mp3) }

    it 'removes mp3 from play_list' do
      post "/api/play_lists/#{play_list.id}/remove_mp3", params: {mp3: { mp3_id: mp3.id}}
      expect{play_list.mp3s.find(mp3.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
