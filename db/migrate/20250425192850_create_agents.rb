class CreateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :agents do |t|
      t.string :name, null: false
      t.references :area, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true
      t.string :status, default: "active"
      t.string :phone
      t.string :email
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
