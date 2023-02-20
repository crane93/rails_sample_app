require "test_helper"

class UsersSignup < ActionDispatch::IntegrationTest

  def setup
    # 他のテストに影響を及ばないようにメール配信をクリア
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  test "invalid signup information" do
    assert_no_difference 'User.count' do #유효하지 않은 유저정보를 입력해 등록되지 않는것을 확인
      post users_path, params: { user: { name:  "",
                                          email: "user@invalid.com",
                                          password:              "fooaaaa",
                                          password_confirmation: "fooaaaa" } }
    end
    assert_response :unprocessable_entity #위의 バリデーションチェック실패로 해당하는 http스테이터스코드가 반환되었는지 확인
    assert_template 'users/new' #그리고 다시 회원가입화면에 돌아오기
    assert_select 'div#error_explanation ul', "Name can't be blank"
  end

  test "valid signup information with account activation" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                          email: "user@valid.com",
                                          password:              "password",
                                          password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup

  def setup
    super
    post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
    @user = assigns(:user)
  end

  test "should not be activated" do
    assert_not @user.activated?
  end

  test "should not be able to log in before account activation" do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid activation token" do
    get edit_account_activation_path("invalid token", email: @user.email)
    assert_not is_logged_in?
  end

  test "should not be able to log in with invalid email" do
    get edit_account_activation_path(@user.activation_token, email: 'wrong')
    assert_not is_logged_in?
  end

  test "should log in successfully with valid activation token and email" do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect! #POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動するメソッド
    assert_template 'users/show' #ユーザーの登録完了後、意図したテンプレートが表示されるかを確認
    assert is_logged_in?
  end
end