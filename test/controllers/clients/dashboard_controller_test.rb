require "test_helper"

class Clients::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clients_dashboard_index_url
    assert_response :success
  end
end
