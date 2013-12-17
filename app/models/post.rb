#encoding: utf-8
class Post < ActiveRecord::Base
  include ChangeHandler
  attr_accessible :post_content, :post_status, :site_id ,:title , :post_img
  has_many :replies

  STATUS = {:normal => 0, :top => 1}
  status_arr = ["normal", "top"]

  status_arr.each do |type|
    #取出等于 type的集合
    scope type.to_sym, :conditions => { :status => STATUS[type.to_sym] }
    define_method  "#{type}?" do
      self.status == STATUS[type.to_sym]
    end
  end

  def comments_count
    @comments_count ||= Reply.includes(:post).where(:post_id => self.id).length
  end
end
