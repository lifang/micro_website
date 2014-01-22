#encoding:utf-8
class Api::ClientsController < ApplicationController
  skip_before_filter :authenticate_user!
  def login
    mphone = params[:mphone]
    pwd = params[:password]
    status = 1
    msg = ""
    user = Client.find_by_mobiephone_and_types(mphone, Client::TYPES[:ADMIN])
    if user.nil?
      status = 0
      msg = "用户名或密码错误!"
    else
      if Digest::MD5.hexdigest(pwd) != user.password
        status = 0
        msg = "密码错误!"
      else
        msg = "登陆成功"
        person_list = Client.find_by_sql(["select c.id, c.name, c.mobiephone, c.avatar_url, c.has_new_message, c.has_new_record
            from clients c where c.site_id=? and c.types=?", user.site_id, Client::TYPES[:CONCERNED]])
        recent_list = RecentlyClients.find_by_sql(["select rc.client_id person_id, rc.content, rc.updated_at date
            from recently_clients rc where rc.site_id=?", user.site_id])
      end
    end
    render :json => {:status => status, :msg => msg, 
      :return_object => {:user => status == 0 ? nil : user.id, :site_id => status == 0 ? nil : user.site_id, :person_list => person_list, :recent_list => recent_list}}
  end

end