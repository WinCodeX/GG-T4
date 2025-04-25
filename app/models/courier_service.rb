class CourierService < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :status, inclusion: { in: ["active", "inactive"] }
  end
  