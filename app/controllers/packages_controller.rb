class PackagesController < ApplicationController
  def create
    @package = Package.new(package_params)

    if @package.save
      render json: { message: "Package created successfully", package: @package }, status: :created
    else
      render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity
    end
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