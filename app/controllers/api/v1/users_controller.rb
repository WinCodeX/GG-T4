class Api::V1::UsersController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :authenticate_user!
  
    def me
      render json: {
        id: current_user.id,
        name: current_user.name,
        email: current_user.email,
        avatar: current_user.avatar.attached? ? url_for(current_user.avatar) : nil
      }
    end
  
    def update
      current_user.assign_attributes(user_params)
      current_user.avatar.attach(params[:avatar]) if params[:avatar].present?
  
      if current_user.save
        render json: {
          status: 'updated',
          name: current_user.name,
          avatar_url: current_user.avatar.attached? ? url_for(current_user.avatar) : nil
        }
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.permit(:name, :avatar)
    end
  end
  