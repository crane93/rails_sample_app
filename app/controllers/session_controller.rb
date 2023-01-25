class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      reset_session #セッション固定攻撃への対策
      log_in user
      redirect_to user
    else
      #エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' #flash.now: 이후 다른리퀘스트가 있다면 flash.now의 메세지는 사라짐
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other #303 See Other
  end
end