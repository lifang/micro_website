#encoding: utf-8
class ImageTextsController < ApplicationController
  before_filter :get_site
  layout 'sites'

  def index
    @title = "微网站-图文"
    @image_texts = @site.pages.image_text.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    @imgs_path = @site.resources
  end

  def new
    @page = Page.new
  end

  def create
    img_path = params[:image_text][:img_path]
    it_content = params[:image_text][:content] if params[:image_text][:content]
    params[:image_text].delete(:content) if params[:image_text][:content]
    params[:image_text].delete(:img_path) if params[:image_text][:img_path]
    params[:image_text][:file_name] = params[:image_text][:file_name] + ".html" if params[:image_text][:file_name]
    @flag = 0
    Page.transaction do
      if it_content.present?
        @page = @site.pages.create(params[:image_text])
        if @page.save
          @page.page_image_texts.create({:img_path => img_path, :content => it_content })
          content = image_text_content(@page, it_content, img_path, @site) if it_content.present?
          save_into_file(content, @page, "") if content
          flash[:notice] = "新建成功!"
          @path = redirect_path(@page, @site)
          render :success
        else
          @flag = 1
          @notice = "新建失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
          render :fail
        end
      else
        @flag = 1
        @notice = "新建失败！ 内容不能为空！"
        render :fail
      end
    end
  end

  def edit
    @page = Page.find_by_id(params[:id])
    if @page
      @image_text = @page.page_image_texts[0]
    end
    render :new
  end

  def update
    @page = Page.find_by_id(params[:id])
    old_page_file_name = @page.file_name
    img_path = params[:image_text][:img_path]
    it_content = params[:image_text][:content]
    params[:image_text].delete(:content) if params[:image_text][:content]
    params[:image_text].delete(:img_path) if params[:image_text][:img_path]
    params[:image_text][:file_name] = params[:image_text][:file_name] + ".html" if params[:image_text][:file_name]
    if @page && @page.update_attributes(params[:image_text])
      @page.page_image_texts[0].update_attributes({:img_path => img_path, :content => it_content })
      content = image_text_content(@page, it_content, img_path, @site) if it_content.present?
      save_into_file(content, @page, old_page_file_name) if content
      flash[:notice] = "更新成功!"
      @path = redirect_path(@page, @site)
      render :success
    else
      @notice = "更新失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
      render :fail
    end
  end
 
end