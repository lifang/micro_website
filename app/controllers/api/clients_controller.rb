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
    user = Client.find_by_username_and_types(mphone, Client::TYPES[:ADMIN])
    if user.nil?
      status = 0
      msg = "用户名或密码错误!"
    else
      if Digest::MD5.hexdigest(pwd) != user.password
        status = 0
        msg = "密码错误!"
      else
        site = Site.find_by_id(user.site_id)
        if site.nil?
          status = 0
          msg = "未知的站点!"
        else
          user.update_attribute("token", token) if token && token.strip != ""
          msg = "登陆成功"
          person_list = Client.find_by_sql(["select c.id, c.name, c.mobiephone, c.avatar_url, c.has_new_message, c.has_new_record,
            c.html_content, c.remark, c.status from clients c where c.site_id=? and c.types=?", user.site_id, Client::TYPES[:CONCERNED]])
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
    end
    render :json => {:status => status, :msg => msg, 
      :return_object => {:user_id => status == 0 ? nil : user.id, :site_id => status == 0 ? nil : site.id,
        :receive_status => status == 0 ? nil : site.receive_status,
        :receive_start => status == 0 || site.not_receive_start_at.nil? ? nil : site.not_receive_start_at.strftime("%H:%M"),
        :receive_end => status == 0 || site.not_receive_end_at.nil? ? nil : site.not_receive_end_at.strftime("%H:%M"),
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
      date_format(m.created_at,'%Y-%m-%d %H:%i') date, m.message_type, m.message_path from messages m
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
            c.html_content, c.remark, c.status from clients c where c.site_id=? and c.types=?", site_id, Client::TYPES[:CONCERNED]])
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

  #编辑联系人信息
  def edit_client
    Client.transaction do
      status = 1
      msg = ""
      site_id = params[:site_id].to_i
      person_id = params[:person_id].to_i
      person_type = params[:person_type]
      person_info = params[:person_info]
      client = Client.find_by_id_and_site_id(person_id, site_id)
      if client.nil? || client.html_content.nil?
        status = 0
        msg = "数据错误!"
      else
        if person_type.eql?("电话")
          if client.update_attribute("mobiephone", person_info)
            msg = "更新成功!"
          else
            status = 0
            msg = "更新失败!"
          end
        elsif person_type.eql?("备注")
          if client.update_attribute("remark", person_info)
            msg = "更新成功!"
          else
            status = 0
            msg = "更新失败!"
          end
        else
          content = []
          client_arr = client.html_content.gsub(/[{}]/,"").split(",")
          client_arr.each do |ca| #"'年龄'=>'sdfs','性别'=>'sdf','爱好'=>'女'"
            ele_arr = ca.gsub(/['"]/,"").split("=>")
            if ele_arr[0].eql?(person_type)
              content << "'#{ele_arr[0]}'=>'#{person_info}'"
            else
              content << ca
            end
          end
          new_str = content.join(",")
          new_str.prepend("{")
          new_str += "}"
          if client.update_attribute("html_content", new_str)
            msg = "更新成功!"
          else
            status = 0
            msg = "更新失败!"
          end
        end

        if status == 0
          c = nil
        else
          c = {:id => client.id, :name => client.name, :mobiephone => client.mobiephone, :avatar_url => client.avatar_url,
            :has_new_message => client.has_new_message, :has_new_record => client.has_new_record, :remark => client.remark,
            :html_content => client.html_content, :status => client.status
          }
        end
      end         
      render :json =>{:status => status, :msg => msg, :return_object => {:person => c}}
    end
  end

  #设置是否屏蔽该联系人消息
  def set_receive
    Client.transaction do
      status = 1
      msg = ""
      person_id = params[:person_id].to_i
      site_id = params[:site_id].to_i
      isShield = params[:isShield].to_i
      client = Client.find_by_id_and_site_id(person_id, site_id)
      if client.nil?
        status = 0
        msg = "数据错误!"
      else
        if client.update_attribute("status", isShield==0 ? false : true)
          msg = "更新成功!"
        else
          status = 0
          msg = "更新失败!"
        end
      end
      if status == 0
        c = nil
      else
        c = {:id => client.id, :name => client.name, :mobiephone => client.mobiephone, :avatar_url => client.avatar_url,
          :has_new_message => client.has_new_message, :has_new_record => client.has_new_record, :remark => client.remark,
          :html_content => client.html_content, :status => client.status
        }
      end
      render :json => {:status => status, :msg => msg, :return_object => {:person => c}}
    end
  end

  #设置免打扰
  def set_undisturbed
    Site.transaction do
      status = 1
      msg = ""
      site_id = params[:site_id].to_i
      #type = params[:type].to_i
      site = Site.find_by_id(site_id)
      receive_status = params[:receive_status].to_i
      receive_start = "#{Time.now.strftime("%Y-%m-%d")} #{params[:receive_start]}"
      receive_end = "#{Time.now.strftime("%Y-%m-%d")} #{params[:receive_end]}"
      hash = {:receive_status => receive_status==0 ? false : true, :not_receive_start_at => receive_start, :not_receive_end_at => receive_end}
      if site.update_attributes(hash)
        msg = "设置成功!"
      else
        status = 0
        msg = "设置失败!"
      end
      render :json => {:status => status, :msg => msg}
    end
  end

end