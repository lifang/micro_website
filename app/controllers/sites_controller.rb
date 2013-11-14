#encoding: utf-8
class SitesController < ApplicationController
  layout 'sites'
  def index
    @sites=current_user.sites.paginate(page: params[:page],:per_page => 9, :order => 'updated_at DESC')
  end

  def create
    if params[:site][:edit_or_create]=='create'
      @site=Site.new()
      @site.name=params[:site][:name]
      @site.root_path=params[:site][:root_path]
      @site.notes=params[:site][:notes]
      @site.status=0
      @site.user_id=current_user.id
      respond_to do |format|
        if @site && @site.save
          flash[:success]='创建成功'
          #  redirect_to root_path
        else
          flash[:error]='创建失败'
        end
        format.js
      end
    else
      update
    end
  end

  def update
    @site=Site.find_by_name(params[:site][:name])
    name=params[:site][:name]
    @root_path=params[:site][:root_path]
    notes=params[:site][:notes]
    respond_to do |format|
      if @site && @site.update_attributes(name:name,root_path:@root_path,notes:notes)
        flash[:success]='更新成功'
        #redirect_to root_path
      else
        flash[:error]='更新失败'
      end
      format.js
    end
  end
  def destroy_site
    @site = Site.find(params[:id])
    if @site.destroy
      flash[:succcess]='删除站点成功'
      r_path=Rails.root.to_s+"/public/"+@site.root_path
      if File::directory?(r_path)
        FileUtils.rm_r r_path
      end
      redirect_to root_path
    else
      flash[:error]='删除失败'
      render 'index'
    end
  end
  private

  def sites_params
    params.require(:site).permit(:name,:root_path,:notes)
  end
end