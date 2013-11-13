
#encoding: utf-8
class ResourcesController < ApplicationController
  SITE_PATH = "/public/%s/"
  require 'fileutils'
  #  require 'rubygems'
  #  require 'zip'
  #require 'archive/zip'

  def index
    @site=Site.find(params[:site_id])

  end

  def create
    @site=Site.find(params[:site_id])
    @tmp = params[:resources][:myfile]
    @resource=@site.resources.build
    @root1_path=@site.root_path
    @resource.path_name=@root1_path+"/resources/"+@tmp.original_filename
    @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"resources"
    @full_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+@tmp.original_filename
    @lim_resource=%w{'zip' 'jpg' 'png' 'mp3' 'mp4' 'avi' 'rm' 'rmvb' 'git' }
    postfix_name=@tmp.original_filename.split('.')[-1]
    if @lim_resource.include?(postfix_name)
      if postfix_name=='zip'
        save_all
      else
        svae_afile @tmp
      end
    redirect_to action:show
    else
      flash[:error]='资源不规范，只能视频，音频，图片，或压缩包'        
    end
  end

  def svae_afile(tmp)
    if @resource.save
      flash[:success]='保存成功'
      save
    else
      flash[:error]='保存失败'
    end
  end

  #zip解压保存
  def save_all
    @full_dir=Rails.root.to_s+SITE_PATH % @root1_path+"temp"
    Archive::Zip.open(@tmp.path) do |z|
      z.extract(@full_dir, :flatten => true)
    end
    arr=[]
    Dir.foreach(@full_dir) do |entry|
      if !File::directory?(entry)
        resour=@site.resources.build
        resour.path_name=@root1_path+"/resources/"+entry
        ful_pa=Rails.root.to_s+SITE_PATH % @root1_path+"temp/"+entry
        ful_path=Rails.root.to_s+SITE_PATH % @root1_path+"resources/"+entry
        if resour.save
          arr<<resour.path_name
          FileUtils.cp  ful_pa,ful_path
        end
      end
    end
    flash[:success]="成功加入#{arr.length}个资源"
    FileUtils.rm_r @full_dir
  end

  def save
    file = File.join("public",@tmp.original_filename)
    #dirname=Rails.root.to_s+SITE_PATH % @root_path+"//resources"
    if !File::directory?( @full_dir )
      FileUtils.mkdir_p(@full_dir)
    end
    file1=File.new(@full_path,'w+')
    FileUtils.cp @tmp.path,file1
  end

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
      render 'resources/index'
    end
  end

  def delete_file(name)
    dirname=Rails.root.to_s+'/public/'+name;
    FileUtils.rm dirname
  end

  #show
  def show
  end

