#encoding: utf-8
class Reply < ActiveRecord::Base
  include ChangeHandler
  attr_accessible :post_id, :reply_content, :send_open_id, :target_open_id
  belongs_to :post
  STATUS_NAME = {1 => "审核通过",2 => "审核未通过", 3 => "已删除"}
  STATUS = {:pass => 1, :not_pass => 2, :deleted => 3}
  status_arr = ["pass", "not_pass", "deleted"]
  status_arr.each do |type|
    #取出等于 type的集合
    scope type.to_sym, :conditions => { :status => STATUS[type.to_sym] }
    define_method  "#{type}?" do
      self.status == STATUS[type.to_sym]
    end
  end

  def show_content
    if self.pass?
      self.reply_content
    elsif self.not_pass?
      "<span style='color:#999'>此评论未通过审核</span>".html_safe
    elsif self.deleted?
      "<span style='color:#999'>此评论已被管理员删除</span>".html_safe
    end
  end

end
