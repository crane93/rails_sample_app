class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token #가상의 속성
  before_save :downcase_email #オブジェクトが保存されるタイミングで処理を実行したいので、before_saveを利用、左のselfは省略不可
  before_create :create_activation_digest # オブジェクトが生成される前に実行
  validates :name, presence: true, length: { maximum: 50 }  #validates라는 메소드에 인수 두개가 들어가있는 것, 두번째 인수는 オプションハッシュ이기때문에 波カッコ를 사용안했음
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  #定数で定義
  validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_secure_password
  validates :password , presence: true, length: { minimum: 6 }, allow_nil: true #has_secure_passwordに存在性のバリデーションも含まれているが、'  'のような空白もOKと判断するため、ここで存在性のバリデーションを追加

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token #selfをつけないとRubyはremember_tokenをローカル変数としてみる
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # セッションハイジャック防止のためにセッショントークンを返す
  # この記憶ダイジェストを再利用しているのは単に利便性のため
  def session_token
    remember_digest || remember
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token) #tokenはこのメソッドで使われるローカル変す、アクセサとは別のもの
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token) #remember_digestの属性はデータベースのカラムに対応しているためActiveRecordで取得と保存が可能
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効化する
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
    # update_columns(activated: true, activated_at: Time.zone.now) 上の２行をまとめたもの、クエリも１個だけ発行される
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワードの再設定メールの有効期限が切れているか確認する
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  # Userオブジェクトからアクセスできないメソッド達、Userオブジェクト内でのみ利用可
  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      email.downcase!
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
