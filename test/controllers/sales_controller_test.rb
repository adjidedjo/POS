require 'test_helper'

class SalesControllerTest < ActionController::TestCase
  setup do
    @sale = sales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, sale: { alamat_kirim: @sale.alamat_kirim, asal_so: @sale.asal_so, customer: @sale.customer, hp1: @sale.hp1, hp2: @sale.hp2, keterangan_customer: @sale.keterangan_customer, nota_bene: @sale.nota_bene, phone_number: @sale.phone_number, salesman_id: @sale.salesman_id, so_manual: @sale.so_manual, spg: @sale.spg, venue_id: @sale.venue_id }
    end

    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should show sale" do
    get :show, id: @sale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sale
    assert_response :success
  end

  test "should update sale" do
    patch :update, id: @sale, sale: { alamat_kirim: @sale.alamat_kirim, asal_so: @sale.asal_so, customer: @sale.customer, hp1: @sale.hp1, hp2: @sale.hp2, keterangan_customer: @sale.keterangan_customer, nota_bene: @sale.nota_bene, phone_number: @sale.phone_number, salesman_id: @sale.salesman_id, so_manual: @sale.so_manual, spg: @sale.spg, venue_id: @sale.venue_id }
    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, id: @sale
    end

    assert_redirected_to sales_path
  end
end
