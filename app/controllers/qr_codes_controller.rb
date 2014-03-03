#encoding: utf-8
class QrCodesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:after_scan]
  before_filter :get_site
  layout 'sites'
  
  def index
    @qr_code = Page.where("site_id = #{@site.id} and types=#{Page::TYPE_NAMES[:sub]} and template = #{Page::TEMPLATE[:qr_code]}")[0]
    @qr_code = Page.new unless @qr_code
    resources_for_select
    @awards =@site.awards.qr_code
  end

  def create
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name]
    Page.transaction do
      @qr_code = @site.pages.create(params[:page])
      if @qr_code
        flash[:notice] = "创建成功"
        redirect_to site_qr_codes_path(@site)
      else
        resources_for_select
        @awards =@site.awards.qr_code
        @error = "创建失败!\\n #{@qr_code.errors.messages.values.flatten.join("\\n")}"
        render :index
      end
    end
  end

  def update
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name]
    @qr_code = Page.find_by_id(params[:id])
    if @qr_code
      Page.transaction do
        if @qr_code.update_attributes(params[:page])
          flash[:notice] = "更新成功"
          redirect_to site_qr_codes_path(@site)
        else
          resources_for_select
          @awards =@site.awards.qr_code
          @error = "更新失败!\\n #{@qr_code.errors.messages.values.flatten.join("\\n")}"
          render :index
        end
      end
    end
  end

  def after_scan
    @qr_code = Page.where("site_id = #{@site.id} and types=#{Page::TYPE_NAMES[:sub]} and template = #{Page::TEMPLATE[:qr_code]}")[0]
    @qr_img = params[:qr_img]
    @code = params[:code]
    render :layout => false
  end
  
end
