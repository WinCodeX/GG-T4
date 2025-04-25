class Package < ApplicationRecord
  include AASM

  enum delivery_type: { door_delivery: 0, agent_pickup: 1, parcel_delivery: 2 }
  enum payment_status: { pending_unpaid: 0, pending: 1, paid: 2 }

  belongs_to :receiver_area, class_name: "Area"
  belongs_to :receiver_location, class_name: "Location"
  belongs_to :courier_service, optional: true
  belongs_to :sender_agent, class_name: "Agent"
  belongs_to :receiver_agent, class_name: "Agent", optional: true

  validates :recipient_name, :recipient_phone, :delivery_type, :sender_agent, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  before_create :generate_tracking_code

  aasm column: :package_status, no_direct_assignment: true do
    state :pending_unpaid, initial: true
    state :pending
    state :dropped
    state :in_transit
    state :delivered
    state :collected
    state :dispatched
  
    event :confirm_payment do
      transitions from: :pending_unpaid, to: :pending
    end
  
    event :drop_off do
      transitions from: :pending, to: :dropped
    end
  
    event :assign_rider do
      transitions from: :dropped, to: :in_transit
    end
  
    event :deliver_to_agent do
      transitions from: :in_transit, to: :delivered
    end
  
    event :collect_at_doorstep do
      transitions from: :in_transit, to: :collected
    end
  
    event :dispatch_to_courier do
      transitions from: :dropped, to: :dispatched
    end
  end

  private

  def generate_tracking_code
    initials = "#{sender_agent.name.first}#{sender_agent.area&.name&.first}#{sender_agent.area&.location&.name&.first}".upcase
    last_package = Package.where("tracking_code LIKE ?", "GG-#{initials}-%").order(created_at: :desc).first

    next_number = if last_package&.tracking_code.present?
                    last_package.tracking_code.split('-').last.to_i + 1
                  else
                    1
                  end

    self.tracking_code = "GG-#{initials}-#{next_number.to_s.rjust(3, '0')}"
  end
end
