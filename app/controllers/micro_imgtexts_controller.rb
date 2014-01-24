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
    #利用时间整数做名字
    timename = Time.new.to_i
    @full_dir =Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message"
    @full_path =Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message/#{timename}.#{postfix_name}"
    @micro_imgtext.img_path ="/allsites/"+ @site.root_path+"/micro_message/#{timename}.#{postfix_name}"
    if @img_resources.include?(postfix_name)
      if @micro_imgtext.save
        if !File::exist?(@full_path)
          FileUtils.mkdir_p @full_dir unless File::directory?( @full_dir )
          file=File.new(@full_path,'wb')
          FileUtils.cp @tmp.path,file
          min_image(@full_path,"#{timename}.#{postfix_name}",@full_dir)
        end
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

  #资源全路径,文件名 ,dir
  def min_image(ful_path,filename,ful_dir)
    target_path=ful_dir+"/"+filename.split(".")[0...-1].join(".")+"_min."+filename.split(".")[-1]
    if !File.exist?(target_path)
      image = MiniMagick::Image.open(ful_path)
      image.resize "360x200"
      image.write  ful_dir+"/"+filename.split(".")[0...-1].join(".")+"_min1."+filename.split(".")[-1]
      image.resize "200x200"
      image.write  ful_dir+"/"+filename.split(".")[0...-1].join(".")+"_min2."+filename.split(".")[-1]
    end
  end
  
  def edit
    
    @micro_imgtext = MicroImgtext.find(params[:micro_imgtext_id])
    @micro_message = MicroMessage.find(params[:micro_message_id]) unless params[:micro_message_id].nil?
  end

  def update
    
    @micro_message = MicroMessage.find(params[:micro_message_id])
    @micro_imgtext = MicroImgtext.find(params[:micro_imgtext_id])
    #利用时间整数做名字
    timename = Time.new.to_i
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
      @full_path=Rails.root.to_s+"/public/allsites/"+ @site.root_path+"/micro_message/#{timename}.#{postfix_name}"
      #更新后的路径
      img_path ="/allsites/"+ @site.root_path+"/micro_message/#{timename}.#{postfix_name}"
      #原先的图片路径
      @Original_img_true_path = Rails.root.to_s+"/public"+ @micro_imgtext.img_path
      #如果图片符合规则
      if @img_resources.include?(postfix_name)
        @micro_imgtext.update_attributes(title:params[:micro_imgtexts][:title],
          content:params[:micro_imgtexts][:content],
          img_path:img_path,
          url:params[:micro_imgtexts][:url])
        #处理文件
        destroy_Original_img @Original_img_true_path
        file=File.new(@full_path,'wb')
        FileUtils.cp @tmp.path,file
        min_image(@full_path,"#{timename}.#{postfix_name}",@full_dir)
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
    @Original_img_true_path = Rails.root.to_s+"/public"+ @micro_imgtext.img_path
    if @micro_imgtext && @micro_imgtext.destroy
      destroy_Original_img @Original_img_true_path
      render :text=>1
    else
      render :text=>0
    end
  end
  #删除图片
  def destroy_Original_img original_img_true_path
    FileUtils.rm original_img_true_path if File::exist?( original_img_true_path )
    FileUtils.rm get_min1_by_imgpath original_img_true_path if File::exist?(get_min1_by_imgpath original_img_true_path)
    FileUtils.rm get_min2_by_imgpath original_img_true_path if File::exist?(get_min2_by_imgpath original_img_true_path)

  end

end
