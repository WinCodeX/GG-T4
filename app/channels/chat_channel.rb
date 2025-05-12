class ChatChannel < ApplicationCable::Channel
    def subscribed
      stream_for ChatRoom.find(params[:room])
    end
  
    def unsubscribed
      # cleanup
    end
  end
  