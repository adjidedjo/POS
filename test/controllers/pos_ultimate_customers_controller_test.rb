require 'test_helper'

class PosUltimateCustomersControllerTest < ActionController::TestCase
  setup do
    @pos_ultimate_customer = pos_ultimate_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pos_ultimate_customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pos_ultimate_customer" do
    assert_difference('PosUltimateCustomer.count') do
      post :create, pos_ultimate_customer: { alamat: @pos_ultimate_customer.alamat, email: @pos_ultimate_customer.email, handphone1: @pos_ultimate_customer.handphone1, handphone: @pos_ultimate_customer.handphone, kode_customer: @pos_ultimate_customer.kode_customer, nama: @pos_ultimate_customer.nama, no_telepon: @pos_ultimate_customer.no_telepon }
    end

    assert_redirected_to pos_ultimate_customer_path(assigns(:pos_ultimate_customer))
  end

  test "should show pos_ultimate_customer" do
    get :show, id: @pos_ultimate_customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pos_ultimate_customer
    assert_response :success
  end

  test "should update pos_ultimate_customer" do
    patch :update, id: @pos_ultimate_customer, pos_ultimate_customer: { alamat: @pos_ultimate_customer.alamat, email: @pos_ultimate_customer.email, handphone1: @pos_ultimate_customer.handphone1, handphone: @pos_ultimate_customer.handphone, kode_customer: @pos_ultimate_customer.kode_customer, nama: @pos_ultimate_customer.nama, no_telepon: @pos_ultimate_customer.no_telepon }
    assert_redirected_to pos_ultimate_customer_path(assigns(:pos_ultimate_customer))
  end

  test "should destroy pos_ultimate_customer" do
    assert_difference('PosUltimateCustomer.count', -1) do
      delete :destroy, id: @pos_ultimate_customer
    end

    assert_redirected_to pos_ultimate_customers_path
  end
end
