#encoding: utf-8
class ImageTextsController < ApplicationController
  before_filter :get_site
  before_filter :resources_for_select, :only => [:new, :edit]
  layout 'sites'

  def index
    @title = "微网站-图文"
    @image_texts = @site.pages.image_text.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
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
          if(params[:onekey][:address].present? || params[:onekey][:phone].present? || params[:onekey][:form_url].present?)
            @page.submit_redirect.create(params[:onekey])
          end
          content = image_text_content(@page, it_content, img_path, @site, params[:onekey], params[:onekey_form][:form_name]) if it_content.present?
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
    @form_pages = @site.pages.form
    if @page
      @image_text = @page.page_image_texts[0]
      @submit_redirect = @page.submit_redirect[0]
      @form = Page.find_by_id(@submit_redirect.form_id) if @submit_redirect && @submit_redirect.form_id
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
          if(params[:onekey][:address].present? || params[:onekey][:phone].present? || params[:onekey][:form_url].present?)
            if @page.submit_redirect[0]
              @page.submit_redirect[0].update_attributes(params[:onekey])
            else
              @page.submit_redirect.create(params[:onekey])
            end
          end
          content = image_text_content(@page, it_content, img_path, @site, params[:onekey], params[:onekey_form][:form_name]) if it_content.present?
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

  def image_text_content(page, it_content, img_path, site, one_key, form_name)
    image_text = ''
    img_path.each_with_index do |img, index|
      if img.present?
        image_text << '<section class="cover_bg title" style="background-image: url(' + '\'' + img + '\'' + ');"></section>'
      end
      image_text << '<section class="text">' + CGI.unescapeHTML(it_content[index]) + '</section>'
    end
    if one_key[:form_id].present?
      form = Page.find_by_id(one_key[:form_id])
      form_path = ("/sites/static?path_name=" + form.path_name) if form
    end
    section_key = (one_key[:address].present? || one_key[:phone].present? || one_key[:form_url].present?) ?
                   '<section class="key">
                     <ul>'+
                      (one_key[:address].present? ?
                        '<li><a href="http://api.map.baidu.com/geocoder?address=' + one_key[:address] + '&output=html" class="adress"><span class="adress_icon">' + one_key[:address] + '</span></a></li>' : '') +
                      (one_key[:phone].present? ?
                        '<li><a href="tel:' + one_key[:phone] + '" class="phone"><span class="phone_icon">' + one_key[:phone] + '</span></a></li>' : '') +
                    '</ul>' +
                    (form.present? ?
                        '<a href='+ form_path +' class="a_btn">'+ form_name +'</a>' : '') +
                   '</section>' : ''

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
            <article style=\"margin-bottom: 50px;\">"+ image_text + section_key +
      "</article>
"+ page_footer(site) +"
        </body>
         <script src=\"/allsites/js/template_main.js\" type=\"text/javascript\"></script>

        </html>"
    content = content.gsub(/<title>.*<\/title>/, "<title>#{page.title}</title>")
    content
  end

 
end