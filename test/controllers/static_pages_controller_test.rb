require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup #インスタンス変数で定義しておく
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should get home" do
    get root_path #get리퀘스트를 home액션에 대해 실행
    assert_response :success  #그러면 결과가 success(http스테이터스코드가 200)가 될것이다
    assert_select "title", "#{@base_title}" #assert_select: 특정 html태그가 존재하는지 테스트
    #assert_select "link", "Home | #{@base_title}"
  end

  test "should get help" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
end
