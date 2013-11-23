#encoding: utf-8
class Page < ActiveRecord::Base
  include ChangeHandler
  after_save :change_stat
  belongs_to :site
  has_many :form_datas, :dependent => :destroy
  attr_accessible :title, :file_name, :types, :site_id, :path_name, :authenticate,:element_relation,:content,:img_path
  attr_accessor :content
  serialize :element_relation
  TYPES_ARR = ['main', 'sub', 'style', 'form']
  TYPE_NAMES = {:main => 0, :sub => 1, :style => 2, :form => 3}
  TYPES = {0 => "主页", 1 => "子页", 2 => "样式表", 3 => "表单"}

  TYPES_ARR.each do |type|
    scope type.to_sym, :conditions => { :types => TYPE_NAMES[type.to_sym] }
    define_method  "#{type}?" do
      self.types == TYPE_NAMES[type.to_sym]
    end
  end
  
  validates :file_name,  :uniqueness => {:scope => :site_id, :case_sensitive => false, :message => "站点内已经存在该文件名"}

end
