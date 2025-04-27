class Users::RegistrationsController < Devise::RegistrationsController
    protected
  
    # Only ask for password if sensitive fields are changed
    def update_resource(resource, params)
      if params[:password].present? || params[:email].present?
        # Require current password if email or password are being updated
        super
      else
        # Allow update without password
        resource.update_without_password(params.except(:current_password))
      end
    end
  end
  