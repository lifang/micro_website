#encoding: utf-8
class PagesController < ApplicationController
  layout 'sites'
  before_filter :get_site

  #主页 index
  def index
    @page = @site.pages.main.first
    if @page
      index_html = File.new(@page.path_name, 'r')
      @index = index_html.read
      index_html.close
      render :edit
    else
      @page = Page.new
      render :new
    end
  end

  #新建page
  def create
    content = params[:page][:content]
    params[:page].delete(params[:page][:content])
    Page.transaction do
      @page = @site.pages.create(params[:page])
      if @page.save
        save_into_file(content, @page)
        @notice = "新建成功!"
        @path = site_pages_path(@site)
        render :success
      else
        @notice="新建失败！ #{@page.errors.messages.values.flatten.join("<\\n>")}"
        render :fail
      end
    end
  end

  #更新page
  def update
    content = params[:page][:content]
    params[:page].delete(params[:page][:content])
    @page = Page.find_by_id params[:id]
    if @page && @page.update_attributes(params[:page])
      save_into_file(content, @page)
      @notice = "更新成功!"
      @path = site_pages_path(@site)
      render :success
    else
      @notice="新建失败！ #{@page.errors.messages.values.flatten.join("<\\n>")}"
      render :fail
    end
  end

  #子页 index
  def sub
    @page = @site.pages.sub.first
  end

  #表单 index
  def form
    
  end

  def preview
    @content = params[:page][:content]
    render :layout => false
  end
  
end