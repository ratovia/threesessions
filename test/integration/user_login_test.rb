require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "rootがhomeかどうか" do
    get root_url
    assert_response :success
    assert_select "form[action='/create']"
    assert_select "form input[name=username]"
    assert_select "h2","input user name"
  end

  test "ユーザ作ってroom一覧表示" do
    get root_url
    post_via_redirect "/create", :username => "test_user"
    assert_select "h2", "test_user"
  end


end