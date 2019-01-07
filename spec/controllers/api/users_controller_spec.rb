require 'rails_helper'
require 'shared/authentication'

RSpec.describe Api::UsersController, type: :controller do

  let(:user) { create(:user) }
  let(:stubbed_user){ double('user') }

  before(:each) {
    request.headers['HTTP_ACCEPT'] = "application/json"
    allow(controller).to receive(:current_user).and_return(user)
    allow(request.env['warden']).to receive(:authenticate!).and_return(stubbed_user)
  }

  describe 'GET #index' do
    
    it_behaves_like "needs authentication", :get, :index
    
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    
    let(:params){ {id: user.to_param} }
    it_behaves_like "needs authentication", :get, :show
    
    it 'returns a success response' do
      get :show, params: params
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) {{
        first_name: 'first_name',
        last_name: 'last_name',
        user_name: 'user_name',
        email: 'user@email.com',
        password: 'password'
      }}

      it 'creates a new User' do
        expect {
          post :create, params: {user: valid_attributes}
        }.to change(User, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: {user: valid_attributes}

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        post :create, params: {user: {first_name: nil}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do

    let(:params) {{id: user.id, user: { first_name: 'new name' }}}
    it_behaves_like "needs authentication", :put, :update

    context 'with valid params' do
      it 'updates the requested user' do
        put :update, params: params
        user.reload
        expect(user.first_name).to eq ('new name')
      end

      it 'returns a success response' do
        put :update, params: {id: user.id, user: user.attributes}
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable_entity response' do
        put :update, params: {id: user.id, user: {first_name: nil} }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    
    let(:params) {{id: user.id}}
    it_behaves_like "needs authentication", :delete, :destroy

    it 'destroys the requested user' do
      expect {
        delete :destroy, params: params
      }.to change(User, :count).by(-1)
    end
  end
end