require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "get home" do
    get "/users/home"
    assert_response :success
    assert_template :home
    assert_template layout: "layouts/application"
  end

  test "post create" do
    post "/users/create", post: {username: "test user"}
    assert_not_nil assigns(@user)
  end

  test "get show" do
    get "/users/show/3"
    assert_not_nil assigns(@user_id)
    assert_not_nil assigns(@room)
  end
end
