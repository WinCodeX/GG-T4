# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  # PATCH/PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # If the user provides a new password, use it
    if account_update_params[:password].present?
      success = resource.update_with_password(account_update_params)
    else
      # Otherwise, update without requiring current password
      success = resource.update_without_password(account_update_params.except(:current_password))
    end

    if success
      set_flash_message :notice, :updated if is_flashing_format?
      bypass_sign_in(resource)
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource, status: :unprocessable_entity
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        redirect_to after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      Rails.logger.debug resource.errors.full_messages
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource, status: :unprocessable_entity
    end
  end

  # Custom action to remove avatar
  def remove_avatar
    current_user.avatar.purge_later
    redirect_to edit_user_registration_path, notice: "Avatar removed."
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :avatar])
  end
end