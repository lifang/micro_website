#encoding:utf-8
class SessionsController < Devise::SessionsController

  # POST /resource/sign_in
  def create
    user=User.where("name=? or email= ?",params[:user][:login],params[:user][:login])
    p 111111111,user
    #禁用用户和删除用
    if user && user[0].status>0
      resource = warden.authenticate!(auth_options)
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      flash[:error]='用户不存在'
      redirect_to '/signin'
    end
  end

end