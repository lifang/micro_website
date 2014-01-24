#encoding: utf-8
class Message < ActiveRecord::Base
  require 'net/http'
  require "uri"
  require 'openssl'
  attr_accessible :content, :from_user, :site_id, :status, :to_user, :types
  TYPES = {:phone => 0, :message => 1, :record => 2, :remind => 3} #0打电话，1信息，2记录，3提醒
  S_TYPES = {0 => "打电话", 1 => "短信", 2 => "记录", 3 => "提醒"}
  STATUS = {:READ => 0, :UNREAD => 1, :ISSUED => 2, :UNISSUED => 3} #该信息0已读，1未读,2已发，3未发

  #发短信url
  MESSAGE_URL = "http://mt.yeion.com"
  USERNAME = "XCRJ"
  PASSWORD = "123456"

  
  def self.create_get_http(url,route)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.port==443
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    request= Net::HTTP::Get.new(route)
    back_res =http.request(request)
    return JSON back_res.body
  end
  #按时发送短信息
  def self.send_message
    Message.transaction do
      message_clients = Message.find_by_sql("select  m.content content,c.mobiephone mobile,m.site_id site_id  from messages m inner join clients c on m.to_user = c.id where  m.status = 3 and m.types = 2")
      message_clients.each do |message_client|
        remind = Remind.find_by_site_id(message_client.site_id)
        today = Time.now.strftime("%Y-%m-%d")
        p Time.now.strftime("%Y-%m-%d")
        p remind.reseve_time.strftime("%Y-%m-%d")
        if today.eql?(remind.reseve_time.strftime("%Y-%m-%d"))
          content = message_client.content
          contents = "请于[[时间=2014-01-25]]到[[选项=一楼]][[填空=做检查]]"
          content_splitleft = contents.split("[[")
          content_splitleft.each do |splitleft|
            if splitleft.include? "]]"
              splitright = splitleft.split("]]")[0]
              content += splitright.split("=")[1]
            else
              if splitright
                content += splitright
              end
            end
          end
          mobilephone = message_client.mobile
          message_route = "/send.do?Account=#{Message::USERNAME}&Password=#{Message::PASSWORD}&Mobile=#{mobilephone}&Content=#{content}&Exno=0"
          create_get_http(Message::MESSAGE_URL, message_route)
        end
      end
    end
  end
end
