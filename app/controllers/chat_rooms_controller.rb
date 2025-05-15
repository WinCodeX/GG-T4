class ChatRoomsController < ApplicationController
    before_action :authenticate_user!
  layout "application"
    def chat_with
      other_user = User.find(params[:id])
      @chat_room = ChatRoom.between(current_user, other_user) ||
                   ChatRoom.create(sender: current_user, receiver: other_user)
  
      redirect_to chat_room_path(@chat_room)
    end

    def index
  @chat_rooms = ChatRoom.for_user(current_user)

  if turbo_frame_request?
    render "chat_rooms/index", locals: { chat_rooms: @chat_rooms }
  else
    render "clients/dashboard/index"
  end
end
  
    def show
      @chat_room = ChatRoom.find(params[:id])
      @messages = @chat_room.messages.includes(:user)
      @chat_with = @chat_room.sender == current_user ? @chat_room.receiver : @chat_room.sender

      @chat_rooms = ChatRoom.for_user(current_user) # <-- required for chatindex

        if turbo_frame_request?
    render partial: "chat_rooms/show", locals: { chat_room: @chat_room, messages: @messages, chat_with: @chat_with }
  else
    render "clients/dashboard/index"
  end
      end
    
  
    def create
      other_user = User.find(params[:user_id])
      @chat_room = ChatRoom.between(current_user.id, other_user.id)
  
      unless @chat_room
        @chat_room = ChatRoom.create(sender: current_user, receiver: other_user)
      end
  
      redirect_to chat_room_path(@chat_room)
    end
  end
  