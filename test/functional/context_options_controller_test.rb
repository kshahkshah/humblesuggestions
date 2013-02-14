require 'test_helper'

class ContextOptionsControllerTest < ActionController::TestCase
  setup do
    @context_option = context_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:context_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create context_option" do
    assert_difference('ContextOption.count') do
      post :create, context_option: { context_id: @context_option.context_id, name: @context_option.name }
    end

    assert_redirected_to context_option_path(assigns(:context_option))
  end

  test "should show context_option" do
    get :show, id: @context_option
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @context_option
    assert_response :success
  end

  test "should update context_option" do
    put :update, id: @context_option, context_option: { context_id: @context_option.context_id, name: @context_option.name }
    assert_redirected_to context_option_path(assigns(:context_option))
  end

  test "should destroy context_option" do
    assert_difference('ContextOption.count', -1) do
      delete :destroy, id: @context_option
    end

    assert_redirected_to context_options_path
  end
end
