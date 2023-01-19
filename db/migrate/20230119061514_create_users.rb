class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t| #create_table：railsのメソッド、|t|：ブロック tableの頭文字を取っただけ、テーブル名は複数形に(users)になっている、モデルでは単数形でしたね
      t.string :name #tオブジェクトを使ってnameとemailのカラムを作ります
      t.string :email

      t.timestamps #マジックカラム（Magic Columns）：created_atとupdated_atという2つのカラムを作ってくれる
    end
  end
end
