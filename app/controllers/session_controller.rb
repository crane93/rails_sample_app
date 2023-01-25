class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      #エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' #flash.now: 이후 다른리퀘스트가 있다면 flash.now의 메세지는 사라짐
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
  end
end