class MakePackageOptionalFieldsNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :packages, :receiver_area_id, true
    change_column_null :packages, :exact_location, true
    change_column_null :packages, :receiver_agent_id, true
    change_column_null :packages, :courier_service_id, true
    change_column_null :packages, :destination, true
  end
end
