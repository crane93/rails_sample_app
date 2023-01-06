require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get static_pages_home_url #get리퀘스트를 home액션에 대해 실행
    assert_response :success  #그러면 결과가 success(http스테이터스코드가 200)가 될것이다
  end

  test "should get help" do
    get static_pages_help_url
    assert_response :success
  end

  test "should get about" do
    get static_pages_about_url
    assert_response :success
  end
end
