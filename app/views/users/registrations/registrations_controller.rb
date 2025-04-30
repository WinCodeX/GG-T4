class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Allow users to update without current password unless changing email or password
  def update_resource(resource, params)
    if sensitive_update?(params)
      super  # Requires current_password
    else
      resource.update_without_password(params.except(:current_password))
    end
  end

  # Determine if sensitive credentials are being changed
  def sensitive_update?(params)
    params[:password].present? || params[:email].present?
  end

  # Explicitly whitelist allowed fields
  def account_update_params
    params.require(:user).permit(
      :username,
      :email,
      :avatar,
      :password,
      :password_confirmation,
      :current_password
    )
  end
end