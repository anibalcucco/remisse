require 'test_helper'

class TrabajosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      login: 'trabajos_test',
      email: 'trabajos_test@example.test',
      password: 'password123',
      password_confirmation: 'password123'
    )
  end

  test 'authenticated index renders payment history' do
    post user_session_path, params: {
      user: { login: @user.login, password: 'password123' }
    }

    get trabajos_path

    assert_response :success
  end
end
