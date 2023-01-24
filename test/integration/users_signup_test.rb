require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path #유저등록 페이지에 액세스
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

  test "valid signup information" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "user",
                                          email: "user@valid.com",
                                          password:              "password",
                                          password_confirmation: "password" } }
    end
    follow_redirect! #POSTリクエストを送信した結果を見て、指定されたリダイレクト先に移動するメソッド
    assert_template 'users/show' #ユーザーの登録完了後、意図したテンプレートが表示されるかを確認
    assert_not flash.empty?
  end
end
