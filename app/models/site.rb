#encoding: utf-8
class Site < ActiveRecord::Base
  
  STATUS = {0 => "新建", 1 => "未审核", 2 => "待审核", 3 => "审核通过",4=>"审核不通过"}
  STATUS_VALUE =[0,1,2,3,4]
  
  
  has_many :resources ,dependent: :destroy
  has_many :pages ,dependent: :destroy
  belongs_to :user
  attr_accessible :name, :root_path, :notes, :user_id
  validates :name ,presence:true,uniqueness: { case_sensitive: false, :message => "名称已存在" }
  validates :root_path ,
   presence:true,
   uniqueness: { case_sensitive: false, :message => "根目录已存在" },
   format:{with:/[a-zA-Z]/i}
end
