class Accounts::SessionsController < Devise::SessionsController
  protected

  def respond_with(resource, _opts = {})
    respond_to do |format|
      format.html { super }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash", locals: { flash: flash })
      }
    end
  end
end