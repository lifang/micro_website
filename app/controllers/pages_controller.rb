#encoding: utf-8
class PagesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:submit_queries, :static, :get_token]
  layout 'sites'
  before_filter :get_site, :except => [:submit_queries]
  caches_action :static
  
  #主页 index
  def index
    @page = @site.pages.main.first
    if @page
      index_html = File.new((PUBLIC_PATH + @page.path_name), 'r') if File.exists?(PUBLIC_PATH + @page.path_name)
      if index_html
        @index = index_html.read
        index_html.close
        render :edit
      else
        render(:file  => "#{Rails.root}/public/404.html",
          :layout => nil,
          :status   => "404 Not Found") 
      end
    else
      @page = Page.new
      render :new
    end
  end

  #新建page
  def create
    content = params[:page][:content]
    img="<img src='"+params[:page][:img_path]+"' width='320'/><br>" if params[:page][:img_path]
    params[:page].delete(:content) if params[:page][:content]
    params[:page][:element_relation] = form_ele_hash(params[:form]) if params[:form]
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name] && params[:page][:file_name] != "style.css"
    Page.transaction do
      @page = @site.pages.create(params[:page])
      if @page.save
        unless @page.main?
          content = modifyContent(@page, content, @site.id,@page.form? ? img : "")
        end
        save_into_file(content, @page, "") if content
        flash[:notice] = "新建成功!"
        @path = redirect_path(@page, @site)
        render :success
      else
        @notice = "新建失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
        render :fail
      end
    end
  end

  #更新page
  def update
    content = params[:page][:content]
    img="<img src='"+params[:page][:img_path]+"' width='320'/><br>" if params[:page][:img_path]
    params[:page].delete(params[:page][:content]) if params[:page][:content]
    params[:page][:element_relation] = form_ele_hash(params[:form]) if params[:form]
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name] && params[:page][:file_name] != "style.css"
    @page = Page.find_by_id params[:id]
    old_page_file_name = @page.file_name
    if @page && @page.update_attributes(params[:page])
      unless @page.main?
        content = modifyContent(@page, content, @site.id,@page.form? ? img : "") if content
      end
      save_into_file(content, @page, old_page_file_name) if content
      flash[:notice] = "更新成功!"
      @path = redirect_path(@page, @site)
      render :success
    else
      @notice = "更新失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
      render :fail
    end
  end

  #删除页面，表单或者子页
  def destroy
    Page.transaction do
      @page = Page.find_by_id params[:id]
      if @page.destroy
        File.delete PUBLIC_PATH + @page.path_name if File.exists?(PUBLIC_PATH + @page.path_name)
        flash[:success]='删除成功！'
        redirect_to redirect_path(@page, @site)
      else
        flash[:error]='删除失败！'
      end
    end
  end

  #子页 index
  def sub
    @sub_pages = @site.pages.sub.order("created_at desc").paginate(:page=>params[:page],:per_page=>10)
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
    index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
    @index = index_html.read
    index_html.close
    render "/pages/sub/sub_edit"
  end

  #样式index
  def style
    @page = @site.pages.style.first
    if @page
      index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
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
    @forms = @site.pages.form.includes(:form_datas).order("created_at desc").paginate(:page=>params[:page],:per_page=>10)
   # @imgs_path=@site.resources
    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page =>params[:id],:per_page=>12)

    render "/pages/form/form"
  end
  #给图片流进行分页（shared/all_img）
  def change
    @site=Site.find(params[:site_id])
    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page =>params[:id],:per_page=>12)
  end

  #表单 new
  def form_new
    @page = Page.new
    render "/pages/form/form_new"
  end

  #表单 edit
  def form_edit
    @page = Page.find_by_id params[:id]
    #开始
    index_html = File.new((PUBLIC_PATH + @page.path_name), 'r')
    @index = index_html.read
    index_html.close
    #结束
    render "/pages/form/form_new"
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

  #表单预览
  def form_preview
    @img = params[:page][:img_path]
    @content = params[:page][:content]
    @title = params[:page][:title]
    render "/pages/form/preview", :layout => false
  end

  #通用表单提交
  def submit_queries
    page = Page.find_by_id params[:id]
    FormData.transaction do
      if current_user
        page.form_datas.create(:data_hash => params[:form], :user_id => current_user.id)
        @notice = 1
      else
        if page.authenticate?
          @notice = 0
        else
          page.form_datas.create(:data_hash => params[:form], :user_id =>nil )
          @notice = 1 
        end
      end
    end
  end

  #访问静态页面
  #TODO访问静态页面报错，暂时设置product.rb里面cache=false
  def static
    path_name = params[:path_name]
    page = Page.find_by_path_name(path_name)
    if page
      site = page.site
      if current_user && (current_user.admin || site.user == current_user)
        redirect_to URI.encode("/allsites" + path_name)
      else
        if site.status == Site::STATUS_NAME[:pass_verified]
          if page.authenticate? && !page.form? && !user_signed_in?
            redirect_to '/signin'
          else
            redirect_to URI.encode("/allsites" + path_name + (params[:secret_key].present? ? "?secret_key=" + params[:secret_key] : ""))
          end
        else
          redirect_to '/303.html', :layout => false
        end
      end
    else
      render Rails.root.to_s + '/public/404.html', :layout => false
    end
  end


  #get form authenticity_token  hack of CSRF
  def get_token
    render :text => form_authenticity_token
  end

end