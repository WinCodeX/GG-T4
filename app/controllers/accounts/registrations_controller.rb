module Accounts
  class RegistrationsController < Devise::RegistrationsController
    def edit
      super
    end

    def update
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

      # Decide whether password is required
      if sensitive_update?(account_update_params)
        success = resource.update_with_password(account_update_params)
      else
        success = resource.update_without_password(account_update_params.except(:current_password))
      end

      if success
        set_flash_message :notice, :updated if is_flashing_format?
        bypass_sign_in(resource)
        respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        render :edit, status: :unprocessable_entity
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