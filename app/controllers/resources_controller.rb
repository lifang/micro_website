#encoding: utf-8
class ResourcesController < ApplicationController
  layout 'sites'
  SITE_PATH = "/public/allsites/%s/"
  require 'fileutils'
  #  require 'rubygems'
  #  require 'zip'
  #require 'archive/zip'

  def index
    @site=Site.find(params[:site_id])
    @resources =classification
  end
  #分类，这里没做分类功能
  def classification
    @site.resources.paginate(page:params[:page],:per_page => 9)
  end
  #得到sql选择语句
  def get_str(name)
   case name
   when 'img'
     "path_name like '%.jpg' or path_name like '%.png' or path_name like '%.gif' or "+
     "path_name like '%.JPG' or path_name like '%.PNG' or path_name like '%.GIF'"
   when 'voice'
     "path_name like '%.mp3' or path_name like '%.wma' or path_name like '%.wav' or "+
     "path_name like '%.MP3' or path_name like '%.WMA' or path_name like '%.WAV'"
   when 'js'
     "path_name like '%.js' or path_name like '%.JS'"
   when 'video'
      "path_name like '%.mp4' or path_name like '%.avi' or path_name like '%.rm' or path_name like '%.rmvb' or path_name like '%.swf' or "+
      "path_name like '%.MP4' or path_name like '%.AVI' or path_name like '%.RM' or path_name like '%.RMVB' or path_name like '%.SWF'"
   end
  end

  def create
   do_create
  end
  #上传功能
  def do_create
    @site=Site.find(params[:site_id])
    @tmp = params[:resources][:myfile]
    @resource=@site.resources.build
    @root1_path=@site.root_path
    postfix_name =@tmp.original_filename.split('.')[-1]
    #小写
    postfix_name =postfix_name.downcase
    #路径名
    @resource.path_name=@root1_path+"/resources/"+@tmp.original_filename
    @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"resources"
    @full_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+@tmp.original_filename
    @lim_resource=%w[zip jpg jpeg png mp3 wma  mp4  3gp gif swf js]
    @img_resources=%w[jpg png gif jpeg]
    @voice_resources=%w[mp3 wma wav]
    @video_resoures=%w[mp4  3gp swf js]
    #创建目录
    resources_dir_exist
    if @lim_resource.include?(postfix_name)
      if postfix_name=='zip'&&@tmp.size<50*1024*1024
        save_all
      elsif @img_resources.include?(postfix_name)&&@tmp.size<1024*1024
        svae_afile @tmp
      elsif @voice_resources.include?(postfix_name)&&@tmp.size<20*1024*1024
        svae_afile @tmp
      elsif @video_resoures.include?(postfix_name)&&@tmp.size<50*1024*1024
        svae_afile @tmp
      else
        flash[:error]='文件大小超限,图片不超过1M，音频不超过20M，视频不超过50M,zip<50M'
      end
      redirect_to site_resources_path(@site)
    else
      redirect_to site_resources_path(@site)
    end
  end


  #判断是否有目录
  def resources_dir_exist
    if !File::directory?( @full_dir )
      FileUtils.mkdir_p(@full_dir)
    end
  end

  ######### 保存一个文件
  def svae_afile(tmp)
    save
    if @resource.save
      flash[:success]='保存成功'
    else
      flash[:error]='文件已经覆盖'
    end
  end

  #zip解压保存
  def save_all
    # @full_path=Rails.root.to_s+SITE_PATH % @root1_path+"temp1/"+@tmp.original_filename
    # @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"temp1"
    #save
    #解压在一个临时目录
    @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"temp"
    #执行解压
    Archive::Zip.open(@tmp.path) do |z|
      z.extract(@full_dir, :flatten => true)
    end
    #转码
    `convmv -f gbk -t utf-8 -r --notest  #{@full_dir}`
    #@full_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+@tmp.original_filename
    arr=[]
    @arr_repeat=0
    arr_error=0
    Dir.foreach(@full_dir) do |entry|
      if !File::directory?(entry)
        postfix_name = entry.split('.')[-1]
        resour=@site.resources.build
        resour.path_name=@root1_path+"/resources/"+entry
        ful_pa=Rails.root.to_s+SITE_PATH % @root1_path+"temp/"+entry
        tmp_file=File.new(ful_pa)
        ful_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+entry
        
        if @img_resources.include?(postfix_name)&&tmp_file.size<1024*1024
          save_from_zip(resour,arr,ful_pa,ful_path)
        elsif @voice_resources.include?(postfix_name)&&tmp_file.size<20*1024*1024
          save_from_zip(resour,arr,ful_pa,ful_path)
        elsif @video_resoures.include?(postfix_name)&&tmp_file.size<50*1024*1024
          save_from_zip(resour,arr,ful_pa,ful_path)
        else
          arr_error+=1
        end      
      end
    end
    flash[:success]="成功加入#{arr.length}个新资源#{message(arr_error,'不符合规范的')}#{message(@arr_repeat,'已存在资源被覆盖')}"
    FileUtils.rm_r @full_dir 
  end
  ## 从zip保存
  def save_from_zip(resour,arr,ful_pa,ful_path)
    if resour.save
      arr<<resour.path_name
      FileUtils.cp  ful_pa,ful_path
    else
      FileUtils.cp  ful_pa,ful_path
      @arr_repeat+=1
    end
  end

  def save
    #file = File.join("public",@tmp.original_filename)
    #dirname=Rails.root.to_s+SITE_PATH % @root_path+"//resources"
    file1=File.new(@full_path,'wb')
    FileUtils.cp @tmp.path,file1
  end


  #是否重复action，以便于action的调用
  def is_not_repeat
    @site=Site.find(params[:id])
    name=@site.root_path+"/resources/"+params[:name]
    @re=Resource.find_by_path_name(name)
    if @re
      render :json => {:status => 0}
    else
      render :json => {:status => 1}
    end
  end
  #删除
  def destroy
    @site=Site.find(params[:site_id])
    @resource=Resource.find(params[:id])
    name=@resource.path_name
    if @resource.destroy
      flash[:success]='删除成功'
      delete_file name
      redirect_to site_resources_path(@site)
    else
      flash[:success]='删除成功'
      redirect_to site_resources_path(@site)
    end
  end
  #删除
  def delete_file(name)
    dirname=Rails.root.to_s+'/public/allsites/'+name;
    FileUtils.rm dirname
  end

  #show the resources
  def show
    @resources =Resource.find(params[:id])
    render 'show' ,:layout=>false
  end
  def image_text
    @site=Site.find(params[:site_id])
    @imgs_path=@site.resources
    render :layouts=>false
  end
  def allimage
    p 111111111111111111111
    @site=Site.find(params[:id])
    @imgs_path=@site.resources
    arr=Array.new
    @imgs_path.each do |path|
      arr<<{src:"http://127.0.0.1:3000/allsites/#{path.path_name}"}
    end
    render :json=>arr
  end
  private
    def message(num,msg)
       if num==0
         ''
       else
         "，有#{num}个#{msg}"
       end
    end
end
