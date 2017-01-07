require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Example User")
  end

  test "制限" do
    assert @user.valid?
  end

  test "存在性" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "一意性" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "関連性" do
    @room = Room.new(name: "Example Room")
    @user.rooms << @room
    assert_includes @user.rooms, @room
  end
end
