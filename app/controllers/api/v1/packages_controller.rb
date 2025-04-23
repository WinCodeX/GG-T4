class Api::V1::PackagesController < ApplicationController
    skip_before_action :verify_authenticity_token
  
    def create
      package = Package.new(package_params)
  
      if package.save
        render json: { status: 'created', package: package }, status: :created
      else
        render json: { status: 'error', errors: package.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def index
      packages = Package.all.order(created_at: :desc)
      render json: packages
    end
  
    def show
      package = Package.find_by(id: params[:id])
      if package
        render json: package
      else
        render json: { error: 'Package not found' }, status: :not_found
      end
    end
  
    private
  
    def package_params
      params.require(:package).permit(:recipient_name, :recipient_phone, :delivery_type, :location)
    end
  end
  