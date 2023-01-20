class AddIndexToUsersEmail < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email, unique: true #인덱스자체에 一意性はないがunique: trueで強制できるようになる
  end
end
