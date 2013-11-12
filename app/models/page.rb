#encoding: utf-8
class Page < ActiveRecord::Base
   belongs_to :site
   attr_accessible :title, :file_name, :types, :site_id, :path_name, :authenticate,:element_relation

   attr_accessor :content
   TYPES_ARR = ['main', 'sub', 'form']
   
   TYPE_NAMES = {:main => 0, :sub => 1, :form => 2}
   TYPES = {0 => "主页", 1 => "子页", 2 => "表单"}

  TYPES_ARR.each do |type|
   scope type.to_sym, :conditions => { :types => type }
  end
end
