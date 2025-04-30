module Accounts
  class RegistrationsController < Devise::RegistrationsController
    def edit
      super
    end

    
  def update
    if params[:user].present? && params[:user][:avatar].present?
      current_user.avatar.attach(params[:user][:avatar])
      redirect_to edit_user_registration_path, notice: "Avatar updated successfully."
    else
      redirect_to edit_user_registration_path, alert: "No avatar selected."
    end
  end

    def update_avatar
      if current_user.update(avatar_params)
        respond_to do |format|
          format.turbo_stream { flash.now[:notice] = "Avatar updated." }
          format.html { redirect_to edit_user_registration_path, notice: "Avatar updated." }
        end
      else
        flash.now[:alert] = "Avatar failed to update."
        render :edit
      end
    end

    def remove_avatar
      current_user.avatar.purge_later
      redirect_to edit_user_registration_path, notice: "Avatar removed."
    end

    private


    before_action :set_devise_mapping
    def set_devise_mapping
      @devise_mapping = Devise.mappings[:user]
    end


    def avatar_params
      params.require(:user).permit(:avatar)
    end

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

    def sensitive_update?(params)
      params[:password].present? || params[:email].present?
    end
  end
end