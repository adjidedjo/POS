require 'test_helper'

class ChannelCustomersControllerTest < ActionController::TestCase
  setup do
    @channel_customer = channel_customers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:channel_customers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create channel_customer" do
    assert_difference('ChannelCustomer.count') do
      post :create, channel_customer: { alamat: @channel_customer.alamat, channel_id: @channel_customer.channel_id, dari_tanggal: @channel_customer.dari_tanggal, kode_channel_customer: @channel_customer.kode_channel_customer, nama: @channel_customer.nama, sampai_tanggal: @channel_customer.sampai_tanggal }
    end

    assert_redirected_to channel_customer_path(assigns(:channel_customer))
  end

  test "should show channel_customer" do
    get :show, id: @channel_customer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @channel_customer
    assert_response :success
  end

  test "should update channel_customer" do
    patch :update, id: @channel_customer, channel_customer: { alamat: @channel_customer.alamat, channel_id: @channel_customer.channel_id, dari_tanggal: @channel_customer.dari_tanggal, kode_channel_customer: @channel_customer.kode_channel_customer, nama: @channel_customer.nama, sampai_tanggal: @channel_customer.sampai_tanggal }
    assert_redirected_to channel_customer_path(assigns(:channel_customer))
  end

  test "should destroy channel_customer" do
    assert_difference('ChannelCustomer.count', -1) do
      delete :destroy, id: @channel_customer
    end

    assert_redirected_to channel_customers_path
  end
end
