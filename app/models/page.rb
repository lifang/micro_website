#encoding: utf-8
class Page < ActiveRecord::Base
  include ChangeHandler
  after_save :change_stat
  belongs_to :site
  has_many :form_datas, :dependent => :destroy
  has_many :page_image_texts, :dependent => :destroy
  attr_accessible :title, :file_name, :types, :site_id, :path_name, :authenticate,:element_relation,:content,:img_path,:page_html,:template
  has_many :submit_redirect, :dependent => :destroy
  accepts_nested_attributes_for :submit_redirect
  attr_accessor :content
  serialize :element_relation
  TYPES_ARR = ['main', 'sub', 'style', 'form', "image_text", "image_stream", "big_image"]
  TYPE_NAMES = {:main => 0, :sub => 1, :style => 2, :form => 3, :image_text => 4, :image_stream => 5, :big_image => 6}
  TYPES = {0 => "主页", 1 => "子页", 2 => "样式表", 3 => "表单", 4 => "图文", 5 => "图片流", 6 => "大图"}

  TEMPLATE = {:self => 0, :model => 1, :ggl => 2, :qr_code => 3}
  TEMPLATE_NAME = {0 => "自定义", 1 => "模板", 2 => "刮刮乐", 3 => "二维码"}
  #template 子页  0是自定义，1是模板  2是刮刮乐 3是二维码

  TYPES_ARR.each do |type|
    #取出等于 type的集合
    scope type.to_sym, :conditions => { :types => TYPE_NAMES[type.to_sym] }
    define_method  "#{type}?" do
      self.types == TYPE_NAMES[type.to_sym]
    end
  end
  
  validates :file_name,  :uniqueness => {:scope => :site_id, :case_sensitive => false, :message => "站点内已经存在该文件名"}

end
