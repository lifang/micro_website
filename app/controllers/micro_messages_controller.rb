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
    @micro_messages =MicroMessage.find_by_id(params[:id])
    if !@micro_messages.nil?
      @img_texts =@micro_messages.micro_imgtexts
      @img_texts.each do |img_text|
        img_text.destroy
        original_img_true_path = Rails.root.to_s+"/public"+ img_text.img_path
        FileUtils.rm original_img_true_path if File::exist?( original_img_true_path )
      end
      @micro_messages.destroy
      flash[:success]="删除成功！"
      redirect_to site_micro_messages_path(@site)
    else
      flash[:success]="删除失败，不存在资源！"
      redirect_to site_micro_messages_path(@site)
    end
  end
end
