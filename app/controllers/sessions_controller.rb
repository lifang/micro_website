class SessionsController < Devise::SessionsController
  
  def new
    super
    render :layout => 'regist'
  end
end