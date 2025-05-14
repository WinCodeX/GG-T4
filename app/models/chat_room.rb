class ChatRoom < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  has_many :messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :receiver_id }

  scope :for_user, ->(user) {
    where("sender_id = :id OR receiver_id = :id", id: user.id)
  }

  def self.between(user1, user2)
    where(sender_id: user1.id, receiver_id: user2.id)
      .or(where(sender_id: user2.id, receiver_id: user1.id))
      .first
  end

  def other_participant(user)
    raise ArgumentError, "User not part of this chat" unless [sender_id, receiver_id].include?(user.id)
    user == sender ? receiver : sender
  end
end