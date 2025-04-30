class Users::RegistrationsController < Devise::RegistrationsController
    protected
  
    # Only ask for password if sensitive fields are 
def update
  self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

  if account_update_params[:password].present?
    result = resource.update_with_password(account_update_params)
  else
    result = resource.update_without_password(account_update_params.except(:current_password))
  end

  if result
    set_flash_message :notice, :updated
    respond_with resource, location: after_update_path_for(resource)
  else
    clean_up_passwords resource
    render :edit, status: :unprocessable_entity
  end
end