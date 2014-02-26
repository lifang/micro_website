#encoding: utf-8
class FormsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:submit_redirect]
  layout 'sites'
  before_filter :get_site, :except => [:submit_redirect]
  before_filter :resources_for_select, :only => [:new, :edit]
  def index
    @forms = @site.pages.form.includes(:form_datas).order("created_at desc").paginate(:page=>params[:page],:per_page=>10)
  end

  def new
    @form = Page.new
    @sub_pages = @site.pages.sub
  end

  def create
    labels = params[:labels]
    options = params[:options]
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name]
    params[:page][:element_relation] = labels if labels
    
    Page.transaction do
      @form = @site.pages.create(params[:page])
      if @form.save
        submit_redirect = @form.submit_redirect.create(params[:tishi])
        redirect_path = submit_redirect_site_form_url(@site, @form)
        content = combine_form_html(@form, labels, options , @site, redirect_path)
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
    @sub_pages = @site.pages.sub
    @submit_redirect = @form.submit_redirect[0]
    render :new
  end

  def update
    labels = params[:labels]
    labels_param = labels.dup
    options = params[:options]
    params[:page][:file_name] = params[:page][:file_name] + ".html" if params[:page][:file_name]
    params[:page][:element_relation] = labels_param if labels
    @form = Page.find_by_id params[:id]
    Page.transaction do
      params[:page][:element_relation].delete_if{|k,v| k.include?("text")}
      if @form.update_attributes(params[:page])
        if @form.submit_redirect[0]
          submit_redirect = @form.submit_redirect[0].update_attributes(params[:tishi])
        else
          submit_redirect = @form.submit_redirect.create(params[:tishi])
        end
        redirect_path = submit_redirect_site_form_url(@site, @form)
        content = combine_form_html(@form, labels, options , @site, redirect_path)
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

  def submit_redirect
    @site = Site.find_by_id params[:site_id]
    @form = Page.find_by_id(params[:id])
    @submit_redirect = @form.submit_redirect[0]
    render :layout => false
  end


  private

  def combine_form_html(page, labels, options , site, redirect_path)
    form_ele = ''
    labels.each do |name, value|
      name_str = name.to_s
      if name_str.include?("input")
        form_ele << "<div class='options'><li><label>#{value}</label><input name=\"form[#{name}]\" class='questionTitle' type=\"text\"></li></div>"
      elsif name_str.include?("radio")
        form_ele << "<h2>#{value}</h2><div class='options options2'>"
        options[name].each do |option|
          form_ele << "<li><input name=\"form[#{name}]\" class='questionTitle' type=\"radio\" value=\"#{option}\"><p>#{option}</p></li>"
        end
        form_ele << "</div>"
      elsif name_str.include?("checkbox")
        form_ele << "<h2>#{value}</h2><div class='options options2'>"
        options[name].each do |option|
           if option == "其他"
              form_ele << "<li><input class='questionTitle' type=\"checkbox\"><p>#{option}</p><input name=\"form[#{name}][]\" type=\"text\"></li>"
           else
             form_ele << "<li><input name=\"form[#{name}][]\" class='questionTitle' type=\"checkbox\" value=\"#{option}\"><p>#{option}</p></li>"
           end
        end
        form_ele << "</div>"
      elsif name_str.include?("select")
        form_ele << "<h2>#{value}</h2><div class='options'>"
        form_ele << "<li><select name=\"form[#{name}]\" class='questionTitle'>"
        options[name].each do |option|
          form_ele << "<option>#{option}</option>"
        end
        form_ele << "</select></li></div>"
      elsif name_str.include?("text")
        form_ele << "<div class='options'><li><label>#{value}</label></li></div>"
      end
    end
    model_html = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">
<html xmlns=\"http://www.w3.org/1999/xhtml\">
<head>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
                    <link href='/allsites/style/template_style.css' media='all' rel='stylesheet' type='text/css'></link>
                    <script src='/allsites/js/jQuery-v1.9.0.js' type='text/javascript'></script>
                  <script src='/allsites/js/form.js' type='text/javascript'></script>
                  <script src=\"/allsites/js/template_main.js\" type=\"text/javascript\"></script>
                    <title>preview</title>
                  </head>
                  <body>
                      <article>
                         <img src='#{ page.img_path}' width='100%'/>
                         <form accept-charset='UTF-8' action='/sites/#{site.id}/pages/#{page.id}/submit_queries' class='submit_form_static' method='post' data-redirect_path='#{redirect_path}'>
                             <div style=\"margin:0;padding:0;display:inline\">
                            <input name=\"utf8\" type=\"hidden\" value=\"✓\">
                            <input class='authenticity_token' name=\"authenticity_token\" type=\"hidden\" value=''></div>
                           <section class=\"form_list\">
                                <ul>" + form_ele +"</ul>
                                <div class=\"form_btn\"><button type='button' onclick=\"return submit_form(this)\">确认提交</button></div>
                           </section>
                         </form>

                          <div class='second_box' id='form_view'>
                            <div class='second_content second_content_3'>
                             <span class='second_dtl' id='the_content'></span>
                             <div class='second_box_act' id='form_view_btn'>
                              <a href='' ><span class='r_sure' >确认</span></a>
                             </div>
                            </div>
                           </div>
                      </article>
                  
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