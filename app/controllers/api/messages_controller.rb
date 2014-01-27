#encoding:utf-8
class Api::MessagesController < ApplicationController
  skip_before_filter :authenticate_user!
  #创建记录
  def make_record
    Message.transaction do
      status = 0
      msg = ""
      from_user = params[:from_user].to_i
      to_user = params[:to_user].to_i
      content = params[:content]
      types = params[:types].to_i
      site_id = params[:site_id].to_i
      message = Message.new(:site_id => site_id, :from_user => from_user, :to_user => to_user, :types => types,
        :content => content, :status => Message::STATUS[:READ])
      if message.save
        status = 1
        msg = "保存成功!"
        mess = {:id => message.id, :from_user => message.from_user, :to_user => message.to_user, :types => message.types,
          :content => message.content, :status => message.status,
          :date => message.created_at.nil? ? nil : message.created_at.strftime("%Y-%m-%d %H:%M")}
        if types == Message::TYPES[:remind] #如果是提醒，则要将has_new_record设为1
          person = Client.find_by_id(to_user)
          person.update_attribute("has_new_record", true) if person
        end
      end
      render :json => {:status => status, :msg => msg, :return_object => {:message => mess}}
    end
  end

  #编辑记录
  def edit_record
    Message.transaction do
      type = params[:type].to_i #0编辑，1删除
      status = 0
      msg = ""
      m_id = params[:message_id].to_i
      message = Message.find_by_id(m_id)
      has_remind = 0
      if message
        if type == 0 #编辑该记录
          content = params[:content]
          if content && message.update_attribute("content", content)
            status = 1
            msg = "编辑成功!"
            mess = {:id => message.id, :from_user => message.from_user, :to_user => message.to_user, :types => message.types,
              :content => message.content, :status => message.status,
              :date => message.created_at.nil? ? nil : message.created_at.strftime("%Y-%m-%d %H:%M")}
          end
        elsif type == 1
          from_user = message.from_user
          to_user = message.to_user
          site_id = message.site_id
          message.destroy
          status = 1
          msg = "删除成功!"
          if message.types == Message::TYPES[:remind]
            left_messages = Message.where(["site_id=? and from_user=? and to_user=? and types=? and status=?", site_id, from_user,
                to_user, Message::TYPES[:remind], Message::STATUS[:READ]]).length
            if left_messages > 0  #有剩余未读提醒
              client = Client.find_by_id(to_user)
              client.update_attribute("has_new_record", true) if client
              has_remind = 1                        
            end
          end
       
        end
      else
        msg = "数据错误!"
      end
      render :json => {:status => status, :msg => msg, :return_object => {:message => type == 1 ? {} : mess},
        :type => message.nil? ? nil : message.types, :has_remind => has_remind}
    end
  end

end