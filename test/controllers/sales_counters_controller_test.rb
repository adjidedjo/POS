require 'test_helper'

class SalesCountersControllerTest < ActionController::TestCase
  setup do
    @sales_counter = sales_counters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_counters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_counter" do
    assert_difference('SalesCounter.count') do
      post :create, sales_counter: { email: @sales_counter.email, nama: @sales_counter.nama, nik: @sales_counter.nik }
    end

    assert_redirected_to sales_counter_path(assigns(:sales_counter))
  end

  test "should show sales_counter" do
    get :show, id: @sales_counter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_counter
    assert_response :success
  end

  test "should update sales_counter" do
    patch :update, id: @sales_counter, sales_counter: { email: @sales_counter.email, nama: @sales_counter.nama, nik: @sales_counter.nik }
    assert_redirected_to sales_counter_path(assigns(:sales_counter))
  end

  test "should destroy sales_counter" do
    assert_difference('SalesCounter.count', -1) do
      delete :destroy, id: @sales_counter
    end

    assert_redirected_to sales_counters_path
  end
end
