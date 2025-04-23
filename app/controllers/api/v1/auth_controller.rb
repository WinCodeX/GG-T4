class Api::V1::AuthController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def login
      user = User.find_by(email: params[:user][:email])
  
      if user&.valid_password?(params[:user][:password])
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: { id: user.id, email: user.email } }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end
  