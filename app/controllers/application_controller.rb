class ApplicationController < ActionController::Base
include ActionView::RecordIdentifier

    before_action :configure_permitted_parameters, if: :devise_controller?

before_action :update_last_seen, unless: :devise_controller?

def update_last_seen
    return unless current_user

    current_user.update_column(:last_seen_at, Time.current)

    Turbo::StreamsChannel.broadcast_replace_to(
      current_user,
      target: dom_id(current_user, :status),
      partial: "shared/user_avatar_with_name",
      locals: { user: current_user }
    )
  end

protected

def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email, :avatar])
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
