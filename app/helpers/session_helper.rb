module SessionHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id #sessionメソッド：railsで提供しているメソッド、ユーザーのブラウザ内の一時cookiesに暗号化済みのユーザーIDが自動で作成
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    if session[:user_id]
      #メモ化したRubyコード
      #@current_user = @current_user || User.find_by(id: session[:user_id]) と一緒
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
end
