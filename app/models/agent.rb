class Agent < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :area, optional: true
  belongs_to :location, optional: true
  has_many :sent_packages, class_name: "Package", foreign_key: "sender_agent_id"
  has_many :received_packages, class_name: "Package", foreign_key: "receiver_agent_id"

  validates :name, :area, :location, presence: true

  def code_initials
    "#{name&.first || ''}#{area&.first || ''}#{location&.first || ''}".upcase
  end
end
