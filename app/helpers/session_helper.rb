module SessionHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id #sessionメソッド：railsで提供しているメソッド、ユーザーのブラウザ内の一時cookiesに暗号化済みのユーザーIDが自動で作成
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) #대입하고있네? ユーザーIDにユーザーIDのセッションを代入した結果）ユーザーIDのセッションが存在すれば라는 뜻ㅎ
      #メモ化したRubyコード
      #@current_user = @current_user || User.find_by(id: session[:user_id]) と一緒
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil   # 安全のため
  end
end
