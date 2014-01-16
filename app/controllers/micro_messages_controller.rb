#encoding:utf-8
class MicroMessagesController < ApplicationController
  before_filter :get_site
  layout 'sites'
  def index
    @micro_messages =@site.micro_messages.image_text
    arr=[]
    @micro_messages.each  do |x|
      arr<<x.id
    end
    arr=arr.join(",")
    @micro_imgtexts = MicroImgtext.where("micro_message_id in (#{arr})") if arr.present?
    @micro_imgtextss = @micro_imgtexts.group_by{|s| s[:micro_message_id]} if @micro_imgtexts
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
        original_img_true_path = Rails.root.to_s+"/public"+ img_text.img_path
        FileUtils.rm original_img_true_path if File::exist?( original_img_true_path )
        FileUtils.rm get_min1_by_imgpath original_img_true_path if File::exist?( get_min1_by_imgpath original_img_true_path )
        FileUtils.rm get_min2_by_imgpath original_img_true_path if File::exist?( get_min2_by_imgpath original_img_true_path )  
      end
      keyword = @micro_messages.keyword
      if keyword.auto?
        keyword.destroy
      else
        keyword.update_attribute(:micro_message_id, nil)
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
