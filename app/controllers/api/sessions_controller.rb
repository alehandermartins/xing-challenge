require "./lib/modules/jwt_wrapper"
module Api
  class SessionsController < ApiController

    def login
      resource = User.find_for_database_authentication(email: params[:email])
      unless resource
        return render json: { error: "Failed to Login"}, status: 401
      end

      unless resource.valid_password?(params[:password])
        return render json: { error: "Failed to Login"}, status: 401
      end

      sign_in :user, resource
      render json: { jwtToken: JWTWrapper.encode({ user_id: resource.id }) }, status: 200
    end
    
  end
end
