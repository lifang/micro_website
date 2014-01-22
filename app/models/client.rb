class Client < ActiveRecord::Base
  attr_accessible :avatar_url, :has_new_message, :has_new_record, :html_content, :mobiephone, :name, :password, :site_id, :types, :username
  TYPES = {:ADMIN => 0, :CONCERNED => 1}  #0 管理员(从IOS设备上登陆的人)，1关注的用户
  HAS_NEW_MESSAGE = {:NO => 0, :YES => 1} #是否有新消息
  HAS_NEW_RECORD = {:NO => 0, :YES => 1}  #是否有新提醒
end
