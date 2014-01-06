#encoding:utf-8
class MicroImgtextsController < ApplicationController
  before_filter :get_site  
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  def index
  end
  def new

    @micro_message = MicroMessage.find(params[:format]) unless params[:format].nil?
  end
  def create
    
    if params[:micro_message_id]==''
      @micro_message = MicroMessage.create(site_id:@site.id,mtype:1)
    else
      @micro_message = MicroMessage.find(params[:micro_message_id])
    end
    @micro_imgtext = MicroImgtext.new(params[:micro_imgtexts])
    @micro_imgtext.micro_message_id=@micro_message.id
    @tmp = params[:micro_imgtexts][:img_path]
    #图片类别
    @img_resources =%w[jpg png gif jpeg]
    postfix_name = @tmp.original_filename.split('.')[-1].downcase
    
    @full_dir=@full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message"
    @full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message/#{@micro_message.id}"+@tmp.original_filename
    @micro_imgtext.img_path ="/allsites/"+ @site.root_path+"/micro_message/#{@micro_message.id}"+@tmp.original_filename
    if @img_resources.include?(postfix_name)
      if @micro_imgtext.save
        FileUtils.mkdir_p @full_dir unless File::directory?( @full_dir )
        file=File.new(@full_path,'wb')
        FileUtils.cp @tmp.path,file
        flash[:success]='新建消息模块成功'
        redirect_to edit_site_micro_message_path(@site,@micro_message)
      else
        flash[:error]='新建消息模块失败'
        render 'micro_messages/new'
      end
    else
      flash[:error]='只允许（gif，png，jpg）图片'
      render 'micro_messages/new'
    end
  end
  def edit
    
    @micro_imgtext = MicroImgtext.find(params[:micro_imgtext_id])
    @micro_message = MicroMessage.find(params[:micro_message_id]) unless params[:micro_message_id].nil?
  end

  def update
    
    @micro_message = MicroMessage.find(params[:micro_message_id])
    @micro_imgtext = MicroImgtext.find(params[:micro_imgtext_id])
    
    @tmp = params[:micro_imgtexts][:img_path]
    if @tmp.nil?
      @micro_imgtext.update_attributes(title:params[:micro_imgtexts][:title],
        content:params[:micro_imgtexts][:content],
        url:params[:micro_imgtexts][:url])
      flash[:success]='更新成功'
      redirect_to edit_site_micro_message_path(@site,@micro_message)
    else
      #图片类别
      @img_resources =%w[jpg png gif jpeg]
      postfix_name = @tmp.original_filename.split('.')[-1].downcase
      @full_dir=@full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message"
      @full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message/#{@micro_message.id}"+@tmp.original_filename
      #更新后的路径
      img_path ="/allsites/"+ @site.root_path+"/micro_message/#{@micro_message.id}"+@tmp.original_filename
      #原先的图片路径
      @Original_img_true_path = Rails.root.to_s+"/public"+ @micro_imgtext.img_path
      #如果图片符合规则
      if @img_resources.include?(postfix_name)
        @micro_imgtext.update_attributes(title:params[:micro_imgtexts][:title],
          content:params[:micro_imgtexts][:content],
          img_path:img_path,
          url:params[:micro_imgtexts][:url])
        #处理文件
        FileUtils.rm @Original_img_true_path 
        file=File.new(@full_path,'wb')
        FileUtils.cp @tmp.path,file

        flash[:success]='更新成功'
        redirect_to edit_site_micro_message_path(@site,@micro_message)
      else
        flash[:error]='只允许（gif，png，jpg）图片'
      render 'micro_messages/edit'
      end
    end
  end

  def destroy
 
    @micro_message = MicroMessage.find(params[:micro_message_id])
    @micro_imgtext = MicroImgtext.find(params[:micro_imgtext_id])
    if @micro_imgtext && @micro_imgtext.destroy
      render :text=>1
    else
      render :text=>0
    end

  end


end
