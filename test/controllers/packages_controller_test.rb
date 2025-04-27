require "test_helper"

class PackagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get packages_create_url
    assert_response :success
  end
end
