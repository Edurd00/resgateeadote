require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "should get new login page" do
    get login_url
    assert_response :success
  end

  test "should login with valid credentials" do
    post login_url, params: { email: @user.email, password: "password123" }
    assert_redirected_to root_url
    assert_equal @user.id, session[:user_id]
    assert_equal "Login realizado com sucesso!", flash[:notice]
  end

  test "should not login with invalid credentials" do
    post login_url, params: { email: @user.email, password: "wrongpassword" }
    assert_response :unprocessable_content
    assert_nil session[:user_id]
    assert_equal "E-mail ou senha inválidos.", flash[:alert]
  end

  test "should logout using GET" do
    post login_url, params: { email: @user.email, password: "password123" }
    assert_equal @user.id, session[:user_id]

    get logout_url
    assert_redirected_to login_url
    assert_nil session[:user_id]
    assert_equal "Logout realizado com sucesso!", flash[:notice]
  end

  test "should logout using DELETE" do
    post login_url, params: { email: @user.email, password: "password123" }
    assert_equal @user.id, session[:user_id]

    delete logout_url
    assert_redirected_to login_url
    assert_nil session[:user_id]
    assert_equal "Logout realizado com sucesso!", flash[:notice]
  end
end
