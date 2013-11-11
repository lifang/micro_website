#encoding: utf-8
class PagesController < ApplicationController
  layout 'sites'
  before_filter :get_site

  def index
    @page = Page.find_by_types_and_site_id( Page::TYPE_NAMES[:main], @site.id)
    if @page
      render :edit
    else
      @page = Page.new(:types => Page::TYPE_NAMES[:main])
      render :new
    end
  end

  def create
    params[:page][:path_name] = "/#{@site.root_path}/#{params[:page][:file_name]}"
    content = params[:page][:content]
    pages_info = params[:page].except(params[:page][:content])
    @page = @site.pages.create(pages_info)
    if @page.save
      save_into_file(content, @page)
      redirect_to site_pages_path(@site)
    else
      render :new
    end 
  end

  def update
    @page = @site.pages.create(:params[:page].except(params[:page][:content]))
    if @page.save
      redirect_to site_pages_path(@site)
    else
      render :new
    end 
  end

  def preview
    @content = params[:page][:content]
    render :layout => false
  end
  
end