#encoding: utf-8
class PagesController < ApplicationController
  layout 'sites'
  before_filter :get_site

  #主页 index
  def index
    @page = @site.pages.main.first
    if @page
      index_html = File.new((Rails.root.to_s + @page.path_name), 'r')
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
    params[:page].delete(params[:page][:content]) if params[:page][:content]
    Page.transaction do
      @page = @site.pages.create(params[:page])
      if @page.save
        save_into_file(content, @page) if content
        @notice = "新建成功!"
        @path = redirect_path(@page, @site)
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
    params[:page].delete(params[:page][:content]) if params[:page][:content]
    @page = Page.find_by_id params[:id]
    if @page && @page.update_attributes(params[:page])
      save_into_file(content, @page) if content
      @notice = "更新成功!"
      @path = redirect_path(@page, @site)
      render :success
    else
      @notice="新建失败！ #{@page.errors.messages.values.flatten.join("<\\n>")}"
      render :fail
    end
  end

  #删除页面
  def destroy
    Page.transaction do
      @page = Page.find_by_id params[:id]
      if @page.destroy
        File.delete Rails.root.to_s + @page.path_name if File.exists?(Rails.root.to_s + @page.path_name)
        redirect_to sub_site_pages_path(@site)
      end
    end
  end

  #子页 index
  def sub
    @sub_pages = @site.pages.sub
    render "/pages/sub/sub"
  end

  #子页 new
  def sub_new
    @page = Page.new
    render "/pages/sub/sub_new"
  end

  #子页 edit
  def sub_edit
    @page = Page.find_by_id params[:id]
    index_html = File.new((Rails.root.to_s + @page.path_name), 'r')
    @index = index_html.read
    index_html.close
    render "/pages/sub/sub_edit"
  end

  #样式index
  def style
    @page = @site.pages.style.first
    if @page
      index_html = File.new((Rails.root.to_s + @page.path_name), 'r')
      @index = index_html.read
      index_html.close
      render :edit
    else
      @page = Page.new
      render "/pages/style/style_new"
    end
  end

  #表单 index
  def form
    @forms = @site.pages.form
    render "/pages/form/form"
  end

  #子页 new
  def form_new
    @page = Page.new
    render "/pages/form/form_new"
  end

  #子页 edit
  def form_edit
    @page = Page.find_by_id params[:id]
    index_html = File.new((Rails.root.to_s + @page.path_name), 'r')
    @index = index_html.read
    index_html.close
    render "/pages/form/form_edit"
  end

  #子页、表单的访问控制
  def if_authenticate
    @page = Page.find_by_id params[:id]
  end

  #页面编辑时预览
  def preview
    @content = params[:page][:content]
    render :layout => false
  end

  protected
  
  def redirect_path(page, site)
    case page.types
    when Page::TYPE_NAMES[:main]
      site_pages_path(site)
    when Page::TYPE_NAMES[:sub]
      sub_site_pages_path(@site)
    when Page::TYPE_NAMES[:form]
      form_site_pages_path(@site)
    end
  end
  
end