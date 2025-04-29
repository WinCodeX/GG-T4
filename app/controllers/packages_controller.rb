class PackagesController < ApplicationController
  def create
  @package = Package.new(package_params)

  if @package.save
    render json: { message: "Package created successfully", package: @package }, status: :created
  else
    render json: { errors: @package.errors.full_messages }, status: :unprocessable_entity
  end

