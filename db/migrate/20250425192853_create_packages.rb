class CreatePackages < ActiveRecord::Migration[7.0]
  def change
    create_table :packages do |t|
      t.string :recipient_name, null: false
      t.string :recipient_phone, null: false
      t.references :sender_agent, null: false, foreign_key: { to_table: :agents }
      t.references :receiver_agent, foreign_key: { to_table: :agents }
      t.string :delivery_type, null: false
      t.references :receiver_area, null: false, foreign_key: { to_table: :areas }
      t.references :receiver_location, null: false, foreign_key: { to_table: :locations }
      t.string :exact_location    
      t.references :courier_service, foreign_key: true
      t.string :courier_service_manual
      t.string :destination
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.string :payment_status, default: "pending_unpaid"
      t.string :package_status, default: "pending"
      t.check_constraint "package_status IN ('pending', 'in_transit', 'delivered', 'cancelled')", name: "package_status_check"
      t.string :tracking_code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
