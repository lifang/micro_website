#encoding:utf-8
class MicroImgtextsController < ApplicationController
  def index
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
