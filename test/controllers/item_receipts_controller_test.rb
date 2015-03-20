require 'test_helper'

class ItemReceiptControllerTest < ActionController::TestCase
  test "should get receipt" do
    get :receipt
    assert_response :success
  end

end
