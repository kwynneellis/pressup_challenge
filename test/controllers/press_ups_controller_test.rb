require "test_helper"

class PressUpsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get press_ups_index_url
    assert_response :success
  end
end
