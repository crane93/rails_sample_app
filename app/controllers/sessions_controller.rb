class SessionsController < ApplicationController
  def new
  end

  def create
    #ユーザーの認証に必要な情報はparamハッシュから簡単に取得できる
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      reset_session
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      log_in @user
      redirect_to @user #Railsがuser_url(user)と自動的に変換
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
