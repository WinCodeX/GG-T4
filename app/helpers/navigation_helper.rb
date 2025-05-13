module NavigationHelper
  def dashboard_path_for(user)
    case user.role
    when "client"
      Rails.application.routes.url_helpers.clients_dashboard_path
    when "admin"
      Rails.application.routes.url_helpers.admin_dashboard_path
    when "agent"
      Rails.application.routes.url_helpers.agents_dashboard_path
    when "rider"
      Rails.application.routes.url_helpers.riders_dashboard_path
    else
      "#"
    end
   end

  end