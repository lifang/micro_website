#encoding:utf-8
class MicroImgtextsController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
  end
  def new
    @micro_imgtext = MicroMessage.new()
  end
  def create
    @micro_message = MicroMessage.new(params[:micro_messages])
    if @micro_message.save

    else

    end
  end
  def destroy
    
  end
end
