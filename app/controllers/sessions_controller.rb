class SessionsController < ApplicationController
  def new
  end

  def create
    #ユーザーの認証に必要な情報はparamハッシュから簡単に取得できる
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        forwarding_url = session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        log_in @user
        redirect_to forwarding_url || @user #Railsがuser_url(user)と自動的に変換
      else 
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] ='Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in? #user sessionが存在する場合のみ、ログアウト
    redirect_to root_url, status: :see_other #RailsのTurboを使う時は303 see_otherステータスを指定することで、DELETEリクエスト後のリダイレクトが正しく振る舞いするようにする必要がある
  end
end
