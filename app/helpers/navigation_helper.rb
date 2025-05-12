module NavigationHelper
  def dashboard_path_for(user)
  return "#" unless user

  {
    "client" => Rails.application.routes.url_helpers.clients_dashboard_path,
    "admin"  => Rails.application.routes.url_helpers.admin_dashboard_path,
    "agent"  => Rails.application.routes.url_helpers.agents_dashboard_path,
    "rider"  => Rails.application.routes.url_helpers.riders_dashboard_path
  }[user.role] || "#"
end
end