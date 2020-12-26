require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do   #test for full title helper
    assert_equal full_title, "Ruby on Rails Tutorial Sample App"   #assert_equal <expected value>, <actual value>
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
  end
end