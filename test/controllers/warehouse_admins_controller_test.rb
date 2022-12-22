require 'test_helper'

class WarehouseAdminsControllerTest < ActionController::TestCase
  setup do
    @warehouse_admin = warehouse_admins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:warehouse_admins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create warehouse_admin" do
    assert_difference('WarehouseAdmin.count') do
      post :create, warehouse_admin: { branch_id: @warehouse_admin.branch_id, email: @warehouse_admin.email, nama: @warehouse_admin.nama, nik: @warehouse_admin.nik }
    end

    assert_redirected_to warehouse_admin_path(assigns(:warehouse_admin))
  end

  test "should show warehouse_admin" do
    get :show, id: @warehouse_admin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @warehouse_admin
    assert_response :success
  end

  test "should update warehouse_admin" do
    patch :update, id: @warehouse_admin, warehouse_admin: { branch_id: @warehouse_admin.branch_id, email: @warehouse_admin.email, nama: @warehouse_admin.nama, nik: @warehouse_admin.nik }
    assert_redirected_to warehouse_admin_path(assigns(:warehouse_admin))
  end

  test "should destroy warehouse_admin" do
    assert_difference('WarehouseAdmin.count', -1) do
      delete :destroy, id: @warehouse_admin
    end

    assert_redirected_to warehouse_admins_path
  end
end
