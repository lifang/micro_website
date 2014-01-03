#encoding:utf-8
class MicroMessagesController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
    @micro_messages =@site.micro_messages
  end

  def new
    @micro_messages =@site.micro_messages
  end
  def edit
    @micro_message =MicroMessage.find_by_id(params[:id])
    @micro_imgtextss = @micro_message.micro_imgtexts
  end
  def create
    
  end

  def destroy
    
  end
end
