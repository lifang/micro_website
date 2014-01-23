class Message < ActiveRecord::Base
  attr_accessible :content, :from_user, :site_id, :status, :to_user, :types
  TYPES = {:phone => 0, :message => 1, :record => 2, :remind => 3} #0打电话，1信息，2记录，3提醒
  S_TYPES = {0 => "打电话", 1 => "短信", 2 => "记录", 3 => "提醒"}
  STATUS = {:READ => 0, :UNREAD => 1} #该信息0已读，1未读
end
