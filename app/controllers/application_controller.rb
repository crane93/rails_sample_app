class ApplicationController < ActionController::Base
  def hello
    render html: "hi"
  end
end
