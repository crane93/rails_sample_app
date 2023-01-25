class User < ApplicationRecord
  before_save { self.email = email.downcase } #オブジェクトが保存されるタイミングで処理を実行したいので、before_saveを利用
  validates :name, presence: true, length: { maximum: 50 }  #validates라는 메소드에 인수 두개가 들어가있는 것, 두번째 인수는 オプションハッシュ이기때문에 波カッコ를 사용안했음
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  #定数で定義
  validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: true
  has_secure_password
  validates :password , presence: true, length: { minimum: 6 } #has_secure_passwordに存在性のバリデーションも含まれているが、'  'のような空白もOKと判断するため、ここで存在性のバリデーションを追加

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
