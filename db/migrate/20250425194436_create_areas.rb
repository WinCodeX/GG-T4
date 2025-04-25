class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
      t.string :name, null: false
      t.references :location, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end

    add_index :areas, [:name, :location_id], unique: true
  end
end
