require 'test_helper'

class ReturnItemControllerTest < ActionController::TestCase
  test "should get return" do
    get :return
    assert_response :success
  end

  test "should get process_return" do
    get :process_return
    assert_response :success
  end

  test "should get return_by_serial" do
    get :return_by_serial
    assert_response :success
  end

  test "should get process_return_by_serial" do
    get :process_return_by_serial
    assert_response :success
  end

end
