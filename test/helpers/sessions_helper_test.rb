require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup   #no session. only cookies
    @user = users(:michael)
    remember(@user)   #remember(user) in sessions_helper
  end
  
  test "current_user returns right user when session is full" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
  
  
  
end