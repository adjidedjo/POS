require 'test_helper'

class Accounting::StocksControllerTest < ActionController::TestCase
  test "should get mutasi_stock" do
    get :mutasi_stock
    assert_response :success
  end

end
