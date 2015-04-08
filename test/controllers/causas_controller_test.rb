require 'test_helper'

class CausasControllerTest < ActionController::TestCase
  setup do
    @causa = causas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:causas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create causa" do
    assert_difference('Causa.count') do
      post :create, causa: { caratulado: @causa.caratulado, date: @causa.date, rol: @causa.rol, tribunal: @causa.tribunal }
    end

    assert_redirected_to causa_path(assigns(:causa))
  end

  test "should show causa" do
    get :show, id: @causa
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @causa
    assert_response :success
  end

  test "should update causa" do
    patch :update, id: @causa, causa: { caratulado: @causa.caratulado, date: @causa.date, rol: @causa.rol, tribunal: @causa.tribunal }
    assert_redirected_to causa_path(assigns(:causa))
  end

  test "should destroy causa" do
    assert_difference('Causa.count', -1) do
      delete :destroy, id: @causa
    end

    assert_redirected_to causas_path
  end
end
