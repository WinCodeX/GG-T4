module Accounts
  class RegistrationsController < Devise::RegistrationsController
    def edit
      super
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
