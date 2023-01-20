require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup #各テストが走る直前に実行される
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar") #すべてのテスト内でこのインスタンス変数が使えるようになります
  end

  test "should be valid" do #Userオブジェクトの有効性をテスト
    assert @user.valid? #assert： 横の処理がtrueを返したら成功/falseを返したら失敗
  end

  test "name should be present" do #存在性の検証
    @user.name = "      "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "      "
    assert_not @user.valid?
  end

  test "name should not be too long" do #文字の長さの検証
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do #文字の長さの検証
    @user.email = "a" * 244  + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do #メールアドレスの有効性の検証
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid" #assertの第2引数にエラーメッセージを作成
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do 
    #一意性の検証：このテストはDBにデータを登録する必要がある
    #しかしActive Recordはデータベースのレベルでは一意性を保証していないため、emailカラムにindexを追加することにしましょう
    duplicate_user = @user.dup #dupは、同じ属性を持つデータを複製するためのメソッド
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6 #多重代入（Multiple Assignment）
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
