class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

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
  end

  def update
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

    # beforeフィルタ

    # ログイン済みのユーザーか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url, status: :see_other
      end
    end

    # 認可
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
end
