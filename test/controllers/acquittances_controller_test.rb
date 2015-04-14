require 'test_helper'

class AcquittancesControllerTest < ActionController::TestCase
  setup do
    @acquittance = acquittances(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:acquittances)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acquittance" do
    assert_difference('Acquittance.count') do
      post :create, acquittance: { method_of_payment: @acquittance.method_of_payment, no_reference: @acquittance.no_reference, sale_id: @acquittance.sale_id }
    end

    assert_redirected_to acquittance_path(assigns(:acquittance))
  end

  test "should show acquittance" do
    get :show, id: @acquittance
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @acquittance
    assert_response :success
  end

  test "should update acquittance" do
    patch :update, id: @acquittance, acquittance: { method_of_payment: @acquittance.method_of_payment, no_reference: @acquittance.no_reference, sale_id: @acquittance.sale_id }
    assert_redirected_to acquittance_path(assigns(:acquittance))
  end

  test "should destroy acquittance" do
    assert_difference('Acquittance.count', -1) do
      delete :destroy, id: @acquittance
    end

    assert_redirected_to acquittances_path
  end
end
