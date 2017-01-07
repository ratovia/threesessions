require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @room = Room.new(:name => "ルームA")
  end

  test "制限" do
    assert @room.valid?
  end

  test "存在性" do
    @room.name = "     "
    assert_not @room.valid?
  end

  test "関連性" do
    @user = User.new(name: "Example User")
    @room.users << @user
    assert_includes @room.users , @user
  end
end
