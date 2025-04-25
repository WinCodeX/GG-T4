class Area < ApplicationRecord
    belongs_to :location
    has_many :agents
  
    validates :name, presence: true
    validates :location, presence: true
    validates :name, uniqueness: { scope: :location_id, message: "already exists for this location" }
  end
  