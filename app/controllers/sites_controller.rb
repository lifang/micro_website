#encoding: utf-8
class SitesController < ApplicationController
  layout 'sites'
  def index
    @sites=current_user.sites.paginate(page: params[:page],:per_page => 9, :order => 'updated_at DESC')
  end

  def create
    if params[:site][:edit_or_create]=='create'
      @site=Site.new()
      @site.name=params[:site][:name].split(' ').join
      @site.root_path=params[:site][:root_path].gsub(/\/+/, "")
      @site.notes=params[:site][:notes]
      @site.status=0
      @site.user_id=current_user.id
      respond_to do |format|
        if @site && @site.save
          flash[:success]='创建成功'
          #  redirect_to root_path
        else
          flash[:error]="创建失败! #{@site.errors.messages.values.flatten.join("\\n")}"
        end
        format.js
      end
    else
      update
    end
  end

  def update
    @site=Site.find_by_name(params[:origin_name])
    name=params[:site][:name].split(' ').join

    @root_path=params[:site][:root_path].gsub(/\/+/, "")
    notes=params[:site][:notes]
    respond_to do |format|
      if @site && @site.update_attributes(name:name,root_path:@root_path,notes:notes)
        flash[:success]='更新成功'
        #redirect_to root_path
      else
        flash[:error]="更新失败 #{@site.errors.messages.values.flatten.join("\\n")}"
      end
      format.js
    end
  end
  def destroy_site
    @site = Site.find(params[:id])
    if @site.destroy
      flash[:succcess]='删除站点成功'
      r_path=Rails.root.to_s+"/public/allsites/"+@site.root_path
      if File::directory?(r_path)
        FileUtils.rm_r r_path
      end
      redirect_to root_path
    else
      flash[:error]='删除失败'
      render 'index'
    end
  end
  
  
  def change_status #改变站点状态   由2(待审核) 根据参数 ,改变至  3(审核通过),或 4(审核不通过)
      
    puts params
    site =Site.find(params[:sid]) #站点id
    status = params[:status]      #改变至status
    page = params[:page]          #回到页面的页数
      
    if site.update_attribute(:status,status)
      msg='success'
    else
      msg='failed!'
    end
      
      
    if(page==''||page==1)
      redirect_to "/user/manage/2?msg=#{msg}"
    else
      redirect_to "/user/manage/2?page=#{page}&msg=#{msg}"
    end
      
  end
  
  def change_each_status
    site_id=params[:id]
    status=params[:status]
    p site_id,status
    site=Site.find(site_id);
    if site.update_attribute(:status,status)
      render :text=>1
    else
      render :text=>0
    end
  end
  
  private
  def sites_params
    params.require(:site).permit(:name,:root_path,:notes)
  end
  
end