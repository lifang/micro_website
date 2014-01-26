#encoding: utf-8
class FormsController < ApplicationController
  #skip_before_filter :authenticate_user!, :only => [:submit_queries, :static, :get_token]
  layout 'sites'
  before_filter :get_site
  before_filter :resources_for_select, :only => [:new, :edit]
  def index
    @forms = @site.pages.form.includes(:form_datas).order("created_at desc").paginate(:page=>params[:page],:per_page=>10)
  end

  def new
    @form = Page.new
  end

  def create
    labels = params[:labels]
    options = params[:options]
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name]
    params[:page][:element_relation] = labels if labels
    Page.transaction do
      @form = @site.pages.create(params[:page])
      if @form.save
        content = combine_form_html(@form, labels, options , @site.id)
        save_into_file(content, @form, "") if content
        flash[:notice] = "新建成功!"
        @path = redirect_path(@form, @site)
        render :success
      else
        @notice = "新建失败！ #{@form.errors.messages.values.flatten.join("\\n")}"
        render :fail
      end
    end
  end

  def edit
    @form = Page.find_by_id params[:id]
    render :new
  end

  def update
    labels = params[:labels]
    options = params[:options]
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name]
    params[:page][:element_relation] = labels if labels
    @form = Page.find_by_id params[:id]
    Page.transaction do
      if @form.update_attributes(params[:page])
        content = combine_form_html(@form, labels, options , @site.id)
        save_into_file(content, @form, "") if content
        flash[:notice] = "更新成功!"
        @path = redirect_path(@form, @site)
        render :success
      else
        @notice = "更新失败！ #{@form.errors.messages.values.flatten.join("\\n")}"
        render :fail
      end
    end
  end


  private

  def resources_for_select
    @imgs_pathes = return_site_images(@site)
    @imgs_path = @imgs_pathes.paginate(:page =>params[:page] || 1,:per_page=>12)
  end

  def combine_form_html(page, labels, options , site_id)
    form_ele = ''
    labels.each do |name, value|
      name_str = name.to_s
      if name_str.include?("input")
        form_ele << "<div class='options'><li><label>#{value}：</label><input name=\"form[#{name}]\" class='questionTitle' type=\"text\"></li></div>"
      elsif name_str.include?("radio")
        form_ele << "<h2>#{value}</h2><div class='options'>"
        options[name].each do |option|
          form_ele << "<li><input name=\"form[#{name}]\" class='questionTitle' type=\"radio\" value=\"#{option}\"><p>#{option}</p></li>"
        end
        form_ele << "</div>"
      elsif name_str.include?("checkbox")
        form_ele << "<h2>#{value}</h2><div class='options'>"
        options[name].each do |option|
          form_ele << "<li><input name=\"form[#{name}][]\" class='questionTitle' type=\"checkbox\" value=\"#{option}\"><p>#{option}</p></li>"
        end
        form_ele << "</div>"
      elsif name_str.include?("select")
        form_ele << "<h2>#{value}</h2><div class='options'>"
        form_ele << "<li><select name=\"form[#{name}]\" class='questionTitle'>"
        options[name].each do |option|
          form_ele << "<option>#{option}</option>"
        end
        form_ele << "</select></li></div>"
      else
      end
    end
    p "=========================="
    p page.img_path
    model_html = "<!DOCTYPE html>
                 <html>
                  <head>
                    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
                    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
                    <link href='/allsites/style/form_style.css?body=1' media='all' rel='stylesheet' type='text/css'></link>
                    <script src='/allsites/js/jQuery-v1.9.0.js' type='text/javascript'></script>
                    <script src='/allsites/js/form.js' type='text/javascript'></script>
                    <title>preview</title>
                  </head>
                  <body>
                      <article>
                         <section class=\"cover_bg title\" style='background-image:url(\"#{ page.img_path}\");'></section>
                         <form accept-charset='UTF-8' action='/sites/#{site_id}/pages/#{page.id}/submit_queries' class='submit_form_static' method='post'>
                             <div style=\"margin:0;padding:0;display:inline\">
                            <input name=\"utf8\" type=\"hidden\" value=\"✓\">
                            <input class='authenticity_token' name=\"authenticity_token\" type=\"hidden\" value=''></div>
                           <section class=\"form_list\">
                                <ul>" + form_ele +"</ul>
                                <div class=\"form_btn\"><button type='button' onclick=\"return submit_form(this,'/sites/#{site_id}/pages/#{page.id}/submit_queries' )\">确认提交</button></div>
                           </section>
                         <form>

                          <div class='second_box' id='form_view'>
                            <div class='second_content second_content_3'>
                             <span class='second_dtl' id='the_content'></span>
                             <div class='second_box_act' id='form_view_btn'>
                              <a href='' ><span class='r_sure' >确认</span></a>
                             </div>
                            </div>
                           </div>
                      </article>
                      <section class=\"footNav\">
                        <ul>
                            <li class=\"footNav_prev\"><a href=\"#\">前进</a></li>
                            <li class=\"footNav_next\"><a href=\"#\">后退</a></li>
                            <li class=\"footNav_refresh\"><a href=\"#\">刷新</a></li>
                            <li class=\"footNav_home\"><a href=\"#\">首页</a></li>
                        </ul>
                      </section>
                  <script language='javascript' type='text/javascript'>
                          $.ajax({
                              url: '/get_token',
                              type: 'get',
                              dataType: 'text',
                              success:function(data){
                                  var a = $('.authenticity_token');
                                  a.each(function(){
                                    $(this).val(data);
                                  });
                              },
                              error:function(data){
                              }
                          })
                  </script>
               </body>
          </html>"
    #TODO正则中文有问题
    model_html = model_html.gsub(/<title>.*<\/title>/, "<title>#{page.title}</title>")
    model_html
  end

  
end