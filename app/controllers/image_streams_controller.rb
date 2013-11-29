#encoding:utf-8
class ImageStreamsController < ApplicationController
  before_filter :get_site
  SITE_PATH = "/public/allsites/%s/"
  PUBLIC_PATH =  Rails.root.to_s + "/public/allsites"
  def index
    render "demo1", :layout => false
  end
  def img_stream
    @site=Site.find(params[:site_id])
    @image_stream_pages=@site.pages.paginate(page:params[:page])
    @imgs_path=@site.resources
    render :layouts=>false
  end
  
  def create_imgtxt
    name=params[:name];
    title=params[:title];
    check=params[:check];
    imgarr=params[:src].split(",");
    textstr=params[:text].split(",");
    @site=Site.find(params[:site_id]);
    @page=@site.pages.build
    @page.title=title
    @page.file_name=name+".html"
    @page.authenticate=check
    @page.types=5
    @page.path_name="/"+@site.root_path+"/"+name+".html"
    if @page.save
      content=get_content(imgarr,textstr)
      save_in_file(content,@site,@page.file_name)
      render :text=>1
    else
      render :text=>0
    end
  end
  #删除图文页
  def destroy
    @site=Site.find(params[:site_id])
        p 121313131
    Page.transaction do
      @page = Page.find(params[:id])
      if @page.destroy
        File.delete PUBLIC_PATH + @page.path_name if File.exists?(PUBLIC_PATH + @page.path_name)
        flash[:success]='删除成功！'
        redirect_to img_stream_site_image_streams_path(@site)
      else
        flash[:success]='删除shibai ！'
        render 'img_stream'
      end
    end
     
  end
  private
  #保存进
  def save_in_file(content,site,fname)
    site_path = Rails.root.to_s + SITE_PATH % site.root_path
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    File.open(site_path + fname, "wb") do |f|
      f.write(content.html_safe)
    end
  end
  #得到内容
  def get_content(imgarr,textarr)
    str=""
    (0..imgarr.length-1).each do |x|  
    str+="<li><a href='#'><img src='#{imgarr[x]}' width='140' height='222' ><p>#{textarr[x]}</p></a></li>"
    end
    p 1111111111111111111111,str 
    content="
    <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1' /> 
<title>#{@page.title}</title>
<script type='text/javascript' src='/allsites/js/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/main.js'></script>
<script type='text/javascript' src='/allsites/js/jquery.wookmark.js'></script>


<!--iphone4横版
<link href='/allsites/style/iphone4-landscape.css' rel='stylesheet' type='text/css' 
media='only screen and (max-device-width:480px) and (orientation:landscape), only screen and (max-width:480px) and (orientation:landscape)'>

<link href='/allsites/style/iphone4-portrait.css' rel='stylesheet' type='text/css' 
media='only screen and (max-device-width:320px) and (orientation:portrait), only screen and (max-width:320px) and (orientation:portrait)'>
-->

<!--iphone4竖版-->
<link href='/allsites/style/iphone4-portrait.css' rel='stylesheet' type='text/css'>



</head>

<body>
    <article>
          <a href='#' class='showPic_search'>搜索</a>
          <section class='showPic_con'>
              <ul>#{str}</ul>
          </section>
    </article>
    <script type='text/javascript'>
      $(function(){
      $('.showPic_con ul li').wookmark({ 
        container:$('.showPic_con ul'), 
        offset:10, 
        itemWidth:140 
      }); 
    })
    </script>
</body>
</html>
    "
    content
  end

end