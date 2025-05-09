class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters, if: :devise_controller?

protected

def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end


  protect_from_forgery with: :null_session

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end
  
end
