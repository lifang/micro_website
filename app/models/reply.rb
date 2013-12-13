#encoding: utf-8
class Reply < ActiveRecord::Base
  include ChangeHandler
  attr_accessible :post_id, :reply_content, :send_open_id, :target_open_id
  belongs_to :post
  STATUS_NAME = {0 => "未审核", 1 => "已审核"}
  STATUS = {:unverified => 0, :verified => 1}
  status_arr = ["unverified", "verified"]
  status_arr.each do |type|
    #取出等于 type的集合
    scope type.to_sym, :conditions => { :status => STATUS[type.to_sym] }
    define_method  "#{type}?" do
      self.status == STATUS[type.to_sym]
    end
  end

end
