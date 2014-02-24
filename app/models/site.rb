#encoding: utf-8
class Site < ActiveRecord::Base
  
  APP = {:YES=>'1' ,:NO=>'0'}
  STATUS = {0 => "新建", 1 => "未审核", 2 => "待审核", 3 => "审核通过",4=>"审核不通过"}
  STATUS_NAME = {:new => 0, :unverified => 1, :wait_verified => 2, :pass_verified => 3, :fail_varified => 4}
  STATUS_VALUE =[0,1,2,3,4]

  #一段时间内，是否接受微信用户发送的消息
  RECEIVE_STATUS = {:yes => 0, :no => 1}

  #AA是否有权限发送信息给微信用户,1有(服务号), 0(订阅号)没有
  IS_SEND_APP_MSG = {:HAS_AUTH => 1, :HAS_NO_AUTH => 0}

  has_many :clients ,dependent: :destroy
  has_many :keywords ,dependent: :destroy
  has_many :micro_messages ,dependent: :destroy
  has_many :awards ,dependent: :destroy
  has_many :posts ,dependent: :destroy
  has_many :resources ,dependent: :destroy
  has_many :pages ,dependent: :destroy
  belongs_to :user
  attr_accessible :name, :root_path, :notes, :user_id,:cweb, :template ,:exist_app, :receive_status, :not_receive_start_at,:is_send_app_msg, :not_receive_end_at
  validates :name ,presence:true,uniqueness: { case_sensitive: false, :message => "名称已存在" }
  validates :root_path ,
   presence:true,
   uniqueness: { case_sensitive: false, :message => "根目录已存在" },
   format:{with:/[a-zA-Z]/i}
end
