class PackagesController < ApplicationController
  def create
    @package = Package.new(package_params)

    if @package.save
      render json: { message: "Package created successfully", package: @package }, status: :created
    else
      render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    @packages = current_user.packages.order(created_at: :desc)
  end

  def track
    @package = Package.find_by!(tracking_code: params[:tracking_code])
  end
  
  def pay
    @package = Package.find(params[:id])
    # Show payment page or redirect to MPESA/etc
  end
  
  def edit
    @package = Package.find(params[:id])
  end
  

  private

  def package_params
    params.require(:package).permit(
      :recipient_name,
      :recipient_phone,
      :sender_agent_id,
      :receiver_agent_id,
      :receiver_location_id,
      :receiver_area_id,
      :courier_service_id,
      :exact_location,
      :destination,
      :delivery_type,
      :tracking_code,
      :price,
      :package_status,
      :payment_status
    )
  end
end