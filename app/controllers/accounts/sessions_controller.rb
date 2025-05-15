class Accounts::SessionsController < Devise::SessionsController
  protected

  def respond_with(resource, _opts = {})
    respond_to do |format|
      format.html { super }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(
          "flash",
          partial: "shared/flash",
          locals: { flash: flash }
        )
      }
    end
  end

  def destroy
    if current_user
      # Update last seen
      current_user.update_column(:last_seen_at, Time.current)

      # Clear Redis (mark offline)
      Redis.current.del("online_status:#{current_user.id}")

      # Turbo broadcast for real-time UI update
      Turbo::StreamsChannel.broadcast_replace_to(
        "user_status_#{current_user.id}",
        target: dom_id(current_user, :status),
        partial: "shared/user_status",
        locals: { user: current_user }
      )
    end

    super
  end
end