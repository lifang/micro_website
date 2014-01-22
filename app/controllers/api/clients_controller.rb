#encoding:utf-8
class Api::ClientsController < ApplicationController
  skip_before_filter :authenticate_user!
  def index
    mphone = params[:mphone]
    pwd = params[:password]
    status = 1
    msg = ""
    user = Client.find_by_mobiephone(mphone)
    if user.nil?
      status = 0
      msg = "该用户不存在!"
    else
      if Digest::MD5.hexdigest(pwd) != user.password
        status = 0
        msg = "密码错误!"
      elsif user.types != Client::TYPES[:ADMIN]
        status = 0
        msg = "无效的账号!"
      else
        msg = "登陆成功"
      end
    end
    render :json => {:statu => status, :msg => msg}
  end

end