#encoding:utf-8
class Api::ClientsController < ApplicationController
  skip_before_filter :authenticate_user!
  #登陆
  def login
    mphone = params[:mphone]
    pwd = params[:password]
    token = params[:token]
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
        user.update_attribute("token", token) if token && token.strip != ""
        msg = "登陆成功"
        person_list = Client.find_by_sql(["select c.id, c.name, c.mobiephone, c.avatar_url, c.has_new_message, c.has_new_record,
            c.html_content from clients c where c.site_id=? and c.types=?", user.site_id, Client::TYPES[:CONCERNED]])
        recent_list = RecentlyClients.find_by_sql(["select rc.client_id person_id, rc.content, date_format(rc.updated_at, '%Y-%m-%d %H:%i') date
            from recently_clients rc where rc.site_id=?", user.site_id]).uniq
        rl = recent_list.inject([]){|a, r|
          hash = {}
          hash[:person_id] = r.person_id
          hash[:content] = r.content
          hash[:date] = r.date
          s = Message.find_by_from_user_and_status(r.person_id, Message::STATUS[:UNREAD])
          hash[:status] = s.nil? ? 0 : 1
          a << hash;
          a
        }
        remind = Remind.find_by_site_id(user.site_id)
        re_content = remind.content if remind
        record = Record.find_by_site_id(user.site_id)
        rec_content = record.content if record
      end
    end
    render :json => {:status => status, :msg => msg, 
      :return_object => {:user_id => status == 0 ? nil : user.id, :site_id => status == 0 ? nil : user.site_id,
        :user_avatar => status == 0 ? nil : user.avatar_url,
        :person_list => person_list, :recent_list => rl, :remind => re_content, :record => rec_content}}
  end

  #点击某个用户，查看信息详情
  def message_detail
    Message.transaction do
      status = 1
      msg = ""
      page = params[:page].to_i
      page_status = 1
      user_id = params[:user_id].to_i
      site_id = params[:site_id].to_i
      person_id = params[:person_id].to_i
      arr = [user_id, person_id]
      messages = Message.paginate_by_sql(["select m.id, m.from_user, m.to_user, m.types, m.content, m.status,
      date_format(m.created_at,'%Y-%m-%d %H:%i') date from messages m
      where m.site_id=? and m.from_user in (?) and m.to_user in (?) order by m.created_at desc",
          site_id, arr, arr], :per_page => 10, :page => page)
      if messages.blank? || messages.length < 10
        page_status = 0
      else
        next_messages = Message.paginate_by_sql(["select m.id, m.from_user, m.to_user, m.types, m.content, m.status,
      date_format(m.created_at,'%Y-%m-%d %H:%i') date from messages m
      where m.site_id=? and m.from_user in (?) and m.to_user in (?) order by m.created_at desc",
            site_id, arr, arr], :per_page => 10, :page => page + 1)
        if next_messages.blank?
          page_status = 0
        end
      end
      messages2 = messages.reverse
      if messages.any?
        person = Client.find_by_id(person_id)
        person.update_attribute("has_new_message", false) if person
        new_messages = Message.where(["site_id=? and from_user=? and status=?", site_id, person_id, Message::STATUS[:UNREAD]])
        new_messages.each do |nm|
          nm.update_attribute("status", Message::STATUS[:READ])
        end if new_messages.any?
      end
      render :json => {:status => status, :msg => msg, :return_object => {:message_list => messages2, :page_status => page_status}}
    end
  end

  #刷新通讯录和最近联系人
  def refresh
    type = params[:type].to_i
    site_id = params[:site_id].to_i
    h = {}
    status = 1
    msg = ""
    if type == 0  #刷新通讯录
      person_list = Client.find_by_sql(["select c.id, c.name, c.mobiephone, c.avatar_url, c.has_new_message, c.has_new_record,
            c.html_content from clients c where c.site_id=? and c.types=?", site_id, Client::TYPES[:CONCERNED]])
      h[:person_list] = person_list
    else
      recent_list = RecentlyClients.find_by_sql(["select rc.client_id person_id, rc.content, date_format(rc.updated_at, '%Y-%m-%d %H:%i') date
            from recently_clients rc where rc.site_id=?", site_id])
      rl = recent_list.inject([]){|a, r|
        hash = {}
        hash[:person_id] = r.person_id
        hash[:content] = r.content
        hash[:date] = r.date
        s = Message.find_by_from_user_and_status(r.person_id, Message::STATUS[:UNREAD])
        hash[:status] = s.nil? ? 0 : 1
        a << hash;
        a
      }
      h[:recent_list] = rl
    end
    render :json => {:status => status, :msg => msg, :return_object => h}
  end

  #删除最近联系人
  def del_recent_client
    RecentlyClients.transaction do
      status = 1
      msg = ""
      site_id = params[:site_id].to_i
      person_id = params[:person_id].to_i
      recent_person = RecentlyClients.find_by_site_id_and_client_id(site_id, person_id)
      if recent_person.nil?
        status = 0
        msg = "数据错误!"
      else
        recent_person.destroy
        msg = "删除成功!"
      end
      render :json => {:status => status, :msg => msg}
    end
  end

end