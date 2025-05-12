class CreateChatRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_rooms do |t|
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps
    end
  end
end
