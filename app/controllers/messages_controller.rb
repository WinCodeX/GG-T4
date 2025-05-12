class MessagesController < ApplicationController
    def create
      @chat_room = ChatRoom.find(params[:chat_room_id])
      @message = @chat_room.messages.build(message_params)
      @message.user = current_user
  
      if @message.save
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to chat_room_path(@chat_room) }
        end
      else
        # Optionally handle errors
      end
    end
  
    private
  
    def message_params
      params.require(:message).permit(:body)
    end
  end
  