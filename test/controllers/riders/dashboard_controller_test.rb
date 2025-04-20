require "test_helper"

class Riders::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get riders_dashboard_index_url
    assert_response :success
  end
end
