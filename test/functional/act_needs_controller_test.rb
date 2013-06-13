require 'test_helper'

class ActNeedsControllerTest < ActionController::TestCase
  setup do
    @act_need = act_needs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:act_needs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create act_need" do
    assert_difference('ActNeed.count') do
      post :create, act_need: { activity_id: @act_need.activity_id, name: @act_need.name, qty_volunteers: @act_need.qty_volunteers }
    end

    assert_redirected_to act_need_path(assigns(:act_need))
  end

  test "should show act_need" do
    get :show, id: @act_need
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @act_need
    assert_response :success
  end

  test "should update act_need" do
    put :update, id: @act_need, act_need: { activity_id: @act_need.activity_id, name: @act_need.name, qty_volunteers: @act_need.qty_volunteers }
    assert_redirected_to act_need_path(assigns(:act_need))
  end

  test "should destroy act_need" do
    assert_difference('ActNeed.count', -1) do
      delete :destroy, id: @act_need
    end

    assert_redirected_to act_needs_path
  end
end
