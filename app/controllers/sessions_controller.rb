#encoding:utf-8
class SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    p params
    user=User.where("name=? or email= ?",params[:user][:login],params[:user][:login])
    p 111111111,user
    #禁用用户和删除用
    if user!=[]   
      user.each do |u|  
        p u.status
          if u.status.to_i>0
            p u.id
            # resource = warden.authenticate!(auth_options);p 1
            set_flash_message(:notice, :signed_in) if is_navigational_format?;
            sign_in(resource_name, u); 
            respond_with u, :location => after_sign_in_path_for(u)   ;  
            return           #结束方法     
          end
        end  
      flash[:error]='用户不存在或已被禁用'
      redirect_to '/signin'
    else
      flash[:error]='用户不存在或已被禁用'
      redirect_to '/signin'
    end
  end

end