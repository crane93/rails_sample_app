class ApplicationController < ActionController::Base
  include SessionHelper #複数のコントローラからログイン関連のメソッドを呼び出せるようにするため
end
