require 'rails_helper'

RSpec.describe Api::PlayListsController, type: :controller do

  let(:play_list) { create(:play_list) }
  let(:user) { play_list.user }
  let(:stubbed_user){ double('user') }

  before(:each) {
    request.headers['HTTP_ACCEPT'] = "application/json"
    allow(controller).to receive(:current_user).and_return(user)
    allow(request.env['warden']).to receive(:authenticate!).and_return(stubbed_user)
  }

  describe 'GET #index' do
    it "returns invalid login without authentication" do
      allow(request.env['warden']).to receive(:authenticate!).and_call_original
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a success response' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it "returns invalid login without authentication" do
      allow(request.env['warden']).to receive(:authenticate!).and_call_original
      get :show, params: {id: play_list.id}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a success response' do
      get :show, params: {id: play_list.id}
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) {{
        name: 'list_name'
      }}

      it "returns invalid login without authentication" do
        allow(request.env['warden']).to receive(:authenticate!).and_call_original
        put :create, params: {play_list: valid_attributes}
        expect(response).to have_http_status(:unauthorized)
      end

      it 'creates a new Playlist' do
        expect {
          post :create, params: {play_list: valid_attributes}
        }.to change(PlayList, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: {play_list: valid_attributes}

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        post :create, params: {play_list: {name: nil}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    it "returns invalid login without authentication" do

      allow(request.env['warden']).to receive(:authenticate!).and_call_original
      put :update, params: {id: user.id, play_list: { name: 'new name' }}
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with valid params' do
      it 'updates the requested play_list' do
        put :update, params: {id: play_list.id, play_list: { name: 'new name' }}
        play_list.reload
        expect(play_list.name).to eq ('new name')
      end

      it 'returns a success response' do
        put :update, params: {id: play_list.id, play_list: { name: 'new name' }}
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        put :update, params: {id: play_list.id, play_list: {name: nil} }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it "returns invalid login without authentication" do
      allow(request.env['warden']).to receive(:authenticate!).and_call_original
      delete :destroy, params: {id: play_list.id}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'destroys the requested play_list' do
      expect {
        delete :destroy, params: {id: play_list.id}
      }.to change(PlayList, :count).by(-1)
    end
  end

  describe 'POST #add_mp3' do

    let(:mp3) { create(:mp3) }

    it 'returns invalid login without authentication' do
      allow(request.env['warden']).to receive(:authenticate!).and_call_original
      post :add_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 404 if no play_list' do
      post :add_mp3, params: {id: 'invalid_id', mp3: { mp3_id: mp3.id}}
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 if no mp3' do
      post :add_mp3, params: {id: play_list.id, mp3: { mp3_id: 'invalid_id'}}
      expect(response).to have_http_status(:not_found)
    end

    it 'adds mp3 from play_list' do
      expect {
        post :add_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
      }.to change(play_list.mp3s, :count).by(1)
    end

    it 'returns a success response' do
      post :add_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
      expect(response).to be_success
    end
  end

  describe 'POST #remove_mp3' do

    let(:mp3) { create(:mp3) }

    before(:each) do
      post :add_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
    end

    it 'returns invalid login without authentication' do
      allow(request.env['warden']).to receive(:authenticate!).and_call_original
      post :remove_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 404 if no play_list' do
      post :remove_mp3, params: {id: 'invalid_id', mp3: { mp3_id: mp3.id}}
      expect(response).to have_http_status(:not_found)
    end

    it 'returns 404 if no mp3' do
      post :remove_mp3, params: {id: play_list.id, mp3: { mp3_id: 'invalid_id'}}
      expect(response).to have_http_status(:not_found)
    end

    it 'removes mp3 from play_list' do
      expect {
        post :remove_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
      }.to change(play_list.mp3s, :count).by(-1)
    end

    it 'returns a success response' do
      post :remove_mp3, params: {id: play_list.id, mp3: { mp3_id: mp3.id}}
      expect(response).to be_success
    end
  end
end
