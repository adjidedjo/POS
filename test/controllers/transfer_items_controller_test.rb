require 'test_helper'

class TransferItemsControllerTest < ActionController::TestCase
  setup do
    @transfer_item = transfer_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transfer_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transfer_item" do
    assert_difference('TransferItem.count') do
      post :create, transfer_item: { ash: @transfer_item.ash, brg: @transfer_item.brg, jml: @transfer_item.jml, nbrg: @transfer_item.nbrg, tfnmr: @transfer_item.tfnmr, tsh: @transfer_item.tsh }
    end

    assert_redirected_to transfer_item_path(assigns(:transfer_item))
  end

  test "should show transfer_item" do
    get :show, id: @transfer_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transfer_item
    assert_response :success
  end

  test "should update transfer_item" do
    patch :update, id: @transfer_item, transfer_item: { ash: @transfer_item.ash, brg: @transfer_item.brg, jml: @transfer_item.jml, nbrg: @transfer_item.nbrg, tfnmr: @transfer_item.tfnmr, tsh: @transfer_item.tsh }
    assert_redirected_to transfer_item_path(assigns(:transfer_item))
  end

  test "should destroy transfer_item" do
    assert_difference('TransferItem.count', -1) do
      delete :destroy, id: @transfer_item
    end

    assert_redirected_to transfer_items_path
  end
end
