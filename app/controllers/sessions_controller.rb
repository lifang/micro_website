#encoding:utf-8
class SessionsController < Devise::SessionsController
  
  # GET /resource/sign_in
  def new
    resource = build_resource(nil, :unsafe => true)
    clean_up_passwords(resource)
    respond_with(resource, serialize_options(resource))
  end
  
end