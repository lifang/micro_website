#encoding: utf-8
class User < ActiveRecord::Base
  before_create :is_user_exist 
  STATUS = {-1 => "删除", 0 => "禁用", 1 => "启用"}
  STATUS_NAME = {:del => -1 , :forbidden => 0, :normal => 1}
  TYPES = {:admin => 1, :mormal => 0}
  has_many :sites ,dependent: :destroy
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :phone, :email, :password, :password_confirmation, :login
  attr_accessor :login
  after_create :set_type_and_status
  
  def is_user_exist
    user =User.where('name=? or email=?',self.name,self.email)
    if user!=[]
      if is_exist(user)
        self.errors.add(:email , "或者用户名已经存在！" )
        return false
      end
    end

    true
  end
  def is_exist(user)
    user.each do |u|
      if u.status!=-1
        return true
      end    
    end
     return false
  end
  
  def admin
    self.types == TYPES[:admin]
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)     
     where(conditions).where(["(lower(name) = :value OR lower(email) = :value) AND status=1", { :value => login.downcase }]).first     
    else
      where(conditions).first
    end
  end


  def update_with_password_copy(params, *options)
    current_password = params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = if valid_password?(current_password)
      update_attributes(params, *options)
    else
      self.assign_attributes(params, *options)
      self.valid?
      self.errors.add(:current_password, current_password.blank? ? "密码不能为空！" : "密码错误！")
      false
    end

    clean_up_passwords
    result
  end

  private
  def set_type_and_status
    self.status = STATUS_NAME[:normal]
    self.types = TYPES[:mormal]
    self.save
  end

end
