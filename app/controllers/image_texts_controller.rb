#encoding: utf-8
class ImageTextsController < ApplicationController
  before_filter :get_site
  before_filter :resources_for_select, :only => [:new, :edit]
  layout 'sites'

  def index
    @title = "微网站-图文"
    @image_texts = @site.pages.image_text.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    #@imgs_path = @site.resources

    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page =>1,:per_page=>12)
  end

  #给图片流进行分页（shared/all_img）
  def change
    @site=Site.find(params[:site_id])
    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page =>params[:id],:per_page=>12)
  end

  def new
    @page = Page.new
    @form_pages = @site.pages.form
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
    it_content = params[:image_text][:content] if params[:image_text][:content]
    params[:image_text].delete(:content) if params[:image_text][:content]
    params[:image_text].delete(:img_path) if params[:image_text][:img_path]
    params[:image_text][:file_name] = params[:image_text][:file_name] + ".html" if params[:image_text][:file_name]
    @flag = 0
    Page.transaction do
      if it_content.present?
        if @page && @page.update_attributes(params[:image_text])
          @page.page_image_texts[0].update_attributes({:img_path => img_path, :content => it_content })
          content = image_text_content(@page, it_content, img_path, @site) if it_content.present?
          save_into_file(content, @page, old_page_file_name) if content
          flash[:notice] = "更新成功!"
          @path = redirect_path(@page, @site)
          render :success
        else
          @flag = 1
          @notice = "更新失败！ #{@page.errors.messages.values.flatten.join("\\n")}"
          render :fail
        end
      else
        @flag = 1
        @notice = "新建失败！ 内容不能为空！"
        render :fail
      end
    end
  end

  private

  def image_text_content(page, it_content, img_path, site)
    image_text = ''
    img_path.each_with_index do |img, index|
      if img.present?
        image_text << '<img src="' + img + ' />'
      end
      image_text << '<p>' + CGI.unescapeHTML(it_content[index]) + '</p>'
    end

    content = "
    <!doctype html>
        <html>
        <head>
        <meta charset=\"utf-8\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
        <title>title</title>
        <script src=\"/allsites/js/jQuery-v1.9.0.js\" type=\"text/javascript\"></script>
        
        <!--iphone4竖版-->
        <link href=\"/allsites/style/template_style.css\" rel=\"stylesheet\" type=\"text/css\">

        </head>

        <body>
            <article>
                  <section class=\"activity_con\">
                      <h1>#{page.title}</h1>
                      <div class=\"title_info\"><span>#{site.name}</span></div>
                      <div class=\"activity_con_text\">" + image_text + "</div>
                  </section>
            </article>

        </body>

<script src=\"/allsites/js/template_main.js\" type=\"text/javascript\"></script>

        </html>"
    content = content.gsub(/<title>.*<\/title>/, "<title>#{page.title}</title>")
    content
  end

 
end