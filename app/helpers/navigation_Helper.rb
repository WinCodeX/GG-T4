module NavigationHelper
  def dashboard_path_for(user)
    case
    when user.client?
      Rails.application.routes.url_helpers.clients_dashboard_path
    when user.admin?
      Rails.application.routes.url_helpers.admin_dashboard_path
    when user.agent?
      Rails.application.routes.url_helpers.agents_dashboard_path
    when user.rider?
      Rails.application.routes.url_helpers.riders_dashboard_path
    end
  end
end