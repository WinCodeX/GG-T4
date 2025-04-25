class CreateCourierServices < ActiveRecord::Migration[7.0]
  def change
    create_table :courier_services do |t|
      t.string :name, null: false
      t.text :description
      t.string :status, default: "active" # active / inactive

      t.timestamps
    end

    add_index :courier_services, :name, unique: true
  end
end
