#encoding: utf-8
class Page < ActiveRecord::Base
  include ChangeHandler
  after_save :change_stat
  belongs_to :site
  has_many :form_datas, :dependent => :destroy
  has_many :page_image_texts, :dependent => :destroy
  attr_accessible :title, :file_name, :types, :site_id, :path_name, :authenticate,:element_relation,:content,:img_path
  attr_accessor :content
  serialize :element_relation
  TYPES_ARR = ['main', 'sub', 'style', 'form', "image_text", "image_stream", "big_image"]
  TYPE_NAMES = {:main => 0, :sub => 1, :style => 2, :form => 3, :image_text => 4, :image_stream => 5, :big_image => 6}
  TYPES = {0 => "主页", 1 => "子页", 2 => "样式表", 3 => "表单", 4 => "图文", 5 => "图片流", 6 => "大图"}

  TYPES_ARR.each do |type|
    scope type.to_sym, :conditions => { :types => TYPE_NAMES[type.to_sym] }
    define_method  "#{type}?" do
      self.types == TYPE_NAMES[type.to_sym]
    end
  end
  
  validates :file_name,  :uniqueness => {:scope => :site_id, :case_sensitive => false, :message => "站点内已经存在该文件名"}

end
