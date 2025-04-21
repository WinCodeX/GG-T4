module Accounts
  class RegistrationsController < Devise::RegistrationsController
    def edit
      super
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
    

    protected

    def update_resource(resource, params)
      if params[:password].present? || params[:email].present?
        super
      else
        resource.update_without_password(params.except(:current_password))
      end
    end
  end
end
