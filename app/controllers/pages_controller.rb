#encoding: utf-8
class PagesController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:submit_queries, :static, :get_token , :get_form_date]
  layout 'sites'
  before_filter :get_site, :except => [:submit_queries, :get_form_date]
  caches_action :static
  
  #主页 index
  def index
    @page = @site.pages.main.first
    resources_for_select #获得图片
    @sub_pages = @site.pages.sub
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
      @site.update_attribute(:template, params[:site][:template].to_i) if @page.main?
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

  #给图片进行分页（shared/all_img）
  def change
    @site=Site.find(params[:site_id])
    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page => params[:page],:per_page=>12)
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
      render :text => @notice
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
  def model_page
    @page = Page.where("site_id=#{@site.id} and types=0")[0]
    if @page.nil?
      @page = Page.create(title: "index",file_name: "index.html",types:0,site_id: @site.id,path_name:"/public/allsites/#{@site.path_name}/index.html");
    end
    template =params[:template]
    bigimg =params[:big_img]
    imgarr = params[:img_arr]
    alinkarr = params[:img_link]
    html_content = params[:html_content]
    @tmp_dir = Rails.root.to_s + "/public/allsites/#{@site.root_path}/resources"
    if template.to_i == Constant::Template[:temp1]

      if @site.update_attribute(:template,template ) && @page.update_attribute( :page_html,html_content)
        #截背景图片
        #bigimg_min_image bigimg,get_filename(bigimg),@tmp_dir
        #截小图
    
        imgarr_each_img imgarr,"186x186","_m1."

        html_content = model1_html @site,bigimg,imgarr,alinkarr
        #保存成为index
        save_as_index @site,html_content
        render text:1
      else
        render text:0
      end
    elsif template.to_i == Constant::Template[:temp2]
      if @site.update_attribute(:template,template ) && @page.update_attribute( :page_html,html_content)
        imgarr_each_img imgarr,"154x154","_m2."
        html_content = model2_html @site,bigimg,imgarr,alinkarr
        save_as_index @site,html_content
        render text:1
      else
        render text:0
      end
    else
      render text:0
    end
  end
  #截图处理图片数组的每张图片
  def imgarr_each_img imgarr,size,end_name
    imgarr.each do |img|
      img_truepath =Rails.root.to_s + "/public#{img}"
      model_min_image(img_truepath,get_filename(img),@tmp_dir,size,end_name) if File::exist?(img_truepath)
    end
  end
  #得到文件名
  def get_filename(file_path)
    f=file_path.split("/")[-1]
    f
  end

  #model1截图
  def model_min_image(ful_path,filename,ful_dir,size,end_name)
    target_path =ful_dir+"/"+filename.split(".")[0...-1].join(".")+end_name+filename.split(".")[-1]
    if !File.exist?(target_path)
      image = MiniMagick::Image.open(ful_path)
      image.resize size
      image.write  target_path
    end
  end
 
  #get form authenticity_token  hack of CSRF
  def get_token
    render :text => form_authenticity_token
  end

  #保存模板3
  def save_template3
    img_links = params[:img_link]
    img_src = params[:img_src]
    ad_srcs = params[:ad_src]
    page = @site.pages.main[0]
    Page.transaction do
      #begin
        content = initial_template3(img_links, img_src, ad_srcs)
        save_into_file(content, page, page.file_name) if content
        page.update_attribute(:page_html, params[:page][:content].strip)
        @site.update_attribute(:template, Constant::Template[:temp3])

        render :text => "0"
     # rescue
        #render :text => "-1"
      #end
    end
  end

  def tmlt_sub_new
    @imgs_pathes = return_site_images(@site)
    @imgs_path = @imgs_pathes.paginate(:page =>params[:id],:per_page=>12)
    @sub_pages = @site.pages.sub
    render 'pages/sub/tmlt_sub_new'
  end
  def tmlt_sub_create
    @sub_pages = @site.pages.sub
    get_img
    @page = @site.pages.build
    top_img = params[:top_img]
    imgarr = params[:img_src]
    imgarr = imgarr.join('||').split('||')
    link_arr = params[:img_link]
    html_content = params[:html_content]
    title =params[:sub_title]
    name = params[:sub_name]+".html"
    @tmp_dir = Rails.root.to_s + "/public/allsites/#{@site.root_path}/resources"
    @page.title=title
    @page.file_name=name
    @page.types = 1
    @page.template = params[:template]
    @page.path_name ="/#{@site.root_path}/#{name}"
    path = Rails.root.to_s+"/public/allsites/"+@page.path_name
    @page.page_html = html_content
    if @page.save
      imgarr_each_img imgarr,"290x290","_sub."
      content = sub_page_html title,top_img,imgarr,link_arr
      save_as_sub_page @site,path,content
      flash[:success]='创建成功！'
      redirect_to sub_site_pages_path(@site)
    else
      flash[:error]="创建失败,文件名存在！"
      redirect_to tmlt_sub_new_site_pages_path(@site)
    end
  end
  def tmlt_sub_edit
    @page = Page.find_by_id(params[:id])
    @sub_pages = @site.pages.sub
    @imgs_pathes = return_site_images(@site)
    @imgs_path = @imgs_pathes.paginate(:page =>1,:per_page=>12)
    render 'pages/sub/tmlt_sub_edit'
  end

  def tmlt_sub_update
    get_img
    @tmp_dir = Rails.root.to_s + "/public/allsites/#{@site.root_path}/resources"
    @page = Page.find_by_id(params[:id])
    if @page
      top_img = params[:top_img]
      imgarr = params[:img_src]
      imgarr = imgarr.join('||').split('||')
      link_arr = params[:img_link]
      html_content = params[:html_content]
      title =params[:sub_title]
      path = Rails.root.to_s+"/public/allsites/"+@page.path_name
      #name = params[:sub_name]+".html"
      #template = params[:template]
      @page.update_attributes( title:title , page_html:html_content )
      imgarr_each_img imgarr,"290x290","_sub."
      content = sub_page_html title,top_img,imgarr,link_arr
      save_as_sub_page @site,path,content
      flash[:success]='更新成功！'
      redirect_to sub_site_pages_path(@site)
    else
      flash[:error]="更新失败"
      redirect_to tmlt_sub_edit_site_pages_path(@site)
    end
  end
  
  def zdy_sub_create
    @sub_pages = @site.pages.sub
    get_img
    @page = @site.pages.build
    title =params[:sub_title]
    name = params[:sub_name]+".html"
    @page.title=title
    @page.file_name=name
    @page.types = 1
    @page.path_name ="/#{@site.root_path}/#{name}"
    path = Rails.root.to_s+"/public/allsites/"+@page.path_name
    zdy_sub_content = params[:zdy_sub_content]
    if @page.save
      save_as_sub_page @site,path,zdy_sub_content
      flash[:success]='创建成功！'
      redirect_to sub_site_pages_path(@site)
    else
      flash[:error]="创建失败"
      render "pages/sub/tmlt_sub_new"
      # redirect_to tmlt_sub_new_site_pages_path(@site)
    end
  end

  def get_img
    @imgs_pathes = return_site_images(@site)
    @imgs_path = @imgs_pathes.paginate(:page =>params[:id],:per_page=>12)
  end

end