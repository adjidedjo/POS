require 'test_helper'

class AdjusmentsControllerTest < ActionController::TestCase
  setup do
    @adjusment = adjusments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:adjusments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create adjusment" do
    assert_difference('Adjusment.count') do
      post :create, adjusment: { alasan: @adjusment.alasan, channel_customer_id: @adjusment.channel_customer_id, jumlah: @adjusment.jumlah, kode_barang: @adjusment.kode_barang }
    end

    assert_redirected_to adjusment_path(assigns(:adjusment))
  end

  test "should show adjusment" do
    get :show, id: @adjusment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @adjusment
    assert_response :success
  end

  test "should update adjusment" do
    patch :update, id: @adjusment, adjusment: { alasan: @adjusment.alasan, channel_customer_id: @adjusment.channel_customer_id, jumlah: @adjusment.jumlah, kode_barang: @adjusment.kode_barang }
    assert_redirected_to adjusment_path(assigns(:adjusment))
  end

  test "should destroy adjusment" do
    assert_difference('Adjusment.count', -1) do
      delete :destroy, id: @adjusment
    end

    assert_redirected_to adjusments_path
  end
end
