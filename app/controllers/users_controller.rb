class UsersController < ApplicationController
  def show
    @user = User.find(params[:id]) #params[:id]にはリクエストのあれが設定される
    #debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] = "Welcome to the Sample App!" #登録完了後、画面上に表示する歓迎メッセージ、flashの変数にキーを:successにするのが一般
      redirect_to @user #ユーザー登録に成功した場合、新しいテンプレートに遷移させるよりリダイレクトするのが一般, redirect_to user_url(@user)の略
    else
      render 'new', status: :unprocessable_entity #HTTPステータスコード422 Unprocessable Entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def user_params
      # Strong Parameters: 必須パラメータと許可済みパラメータを指定し、安全にユーザーを作成できるようにする
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
