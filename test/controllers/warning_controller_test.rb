require 'test_helper'

class WarningControllerTest < ActionController::TestCase
  test "should get exists" do
    get :exists
    assert_response :success
  end

end
