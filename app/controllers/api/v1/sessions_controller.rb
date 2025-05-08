# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json


      # -------------------------------------------------------
      # POST /api/v1/login
      # -------------------------------------------------------
      def create
        super
      end

      # -------------------------------------------------------
      # DELETE /api/v1/logout
      # -------------------------------------------------------
      def destroy
        super
      end

      private

      # on successful login, Devise::JWT has already set
      # `request.env['warden-jwt_auth.token']` for us.
      # We just pluck it out and render JSON.
      def respond_with(resource, _opts = {})
        render json: {
          token: request.env['warden-jwt_auth.token'],
          user: {
            id:    resource.id,
            email: resource.email,
            name:  resource.username || resource.name
          }
        }, status: :ok
      end

      # on logout we simply return 204 No Content
      def respond_to_on_destroy
        head :no_content
      end
    end
  end
end