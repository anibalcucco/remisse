require 'test_helper'

class BrowsingTest < ActionDispatch::IntegrationTest
  test 'homepage redirects anonymous users to sign in' do
    get '/'
    assert_redirected_to new_user_session_path
  end
end
