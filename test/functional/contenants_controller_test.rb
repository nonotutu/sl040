require 'test_helper'

class ContenantsControllerTest < ActionController::TestCase
  setup do
    @contenant = contenants(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contenants)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contenant" do
    assert_difference('Contenant.count') do
      post :create, contenant: { contenant_id: @contenant.contenant_id, name: @contenant.name }
    end

    assert_redirected_to contenant_path(assigns(:contenant))
  end

  test "should show contenant" do
    get :show, id: @contenant
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contenant
    assert_response :success
  end

  test "should update contenant" do
    put :update, id: @contenant, contenant: { contenant_id: @contenant.contenant_id, name: @contenant.name }
    assert_redirected_to contenant_path(assigns(:contenant))
  end

  test "should destroy contenant" do
    assert_difference('Contenant.count', -1) do
      delete :destroy, id: @contenant
    end

    assert_redirected_to contenants_path
  end
end
