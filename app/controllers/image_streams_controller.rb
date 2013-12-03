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
    p imgarr,textstr
    @site=Site.find(params[:site_id]);
    @page=@site.pages.build
    @page.title=title
    @page.file_name=name+".html"
    @page.authenticate=check
    @page.types=5
    @page.path_name="/"+@site.root_path+"/"+name+".html"
    if @page.save
    
      content=get_content(imgarr,textstr)
      bigcontent=get_bigcontent(imgarr,textstr)
      save_in_file(content,bigcontent,@site,@page.file_name)
      render :text=>1
    else
      render :text=>0
    end
  end

  #删除图文页
  def destroy
    @site=Site.find(params[:site_id])
    Page.transaction do
      @page = Page.find(params[:id])
      if @page.destroy
        bigimg_path=PUBLIC_PATH+"/"+@site.root_path+"/bigimg_"+@page.file_name
        File.delete PUBLIC_PATH + @page.path_name if File.exists?(PUBLIC_PATH + @page.path_name)
        File.delete  bigimg_path if File.exists?(bigimg_path)
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
  def save_in_file(content,bigcontent,site,fname)
    site_path = Rails.root.to_s + SITE_PATH % site.root_path
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    File.open(site_path + fname, "wb") do |f|
      f.write(content.html_safe)
    end
    File.open(site_path + "bigimg_"+fname, "wb") do |fb|
      fb.write(bigcontent.html_safe)
    end
  end

  #得到内容
  def get_content(imgarr,textarr)
    str=""
    (0..imgarr.length-1).each do |x|
      str+="<li><a href='bigimg_#{@page.file_name}#page-#{x+1}'><img src='#{imgarr[x]}' width='140' height='222' ><p>#{textarr[x]}</p></a></li>
      "
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
<!--[if lt IE 9]>
<script src='/allsites/js/html5.js'></script>
<![endif]-->
<link href='/allsites/style/iphone4-portrait.css' rel='stylesheet' type='text/css'>
</head>

<body>
    <article>
          <section class='show_pic'>
              <ul>#{str}</ul>
          </section>
    </article>
    <script type='text/javascript'>
      $(function(){
      $('.show_pic ul li').wookmark({ 
        container:$('.show_pic ul'), 
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

  def get_bigcontent(imgarr,textarr)
    selection="";
    image=""
    (1..imgarr.length).each do|i|
      selection+="<section id='page-#{i}' data-role='page' class='demo-page'><div class=\'show_img si_#{i}\'></div></section>"
      image+=".si_#{i} { background: url('#{imgarr[i-1]}') no-repeat; background-size: 320px auto;}
      "
    end
    bigcontent="
    <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>冯磊微世界</title>
<script type='text/javascript' src='/allsites/js/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/main.js'></script>
<script type='text/javascript' src='/allsites/js/jquery.mobile-1.3.2.js'></script>

<!--[if lt IE 9]>
<script src='/allsites/js/html5.js'></script>
<![endif]-->
<link href='/allsites/style/jquery.mobile-1.3.2.css' rel='stylesheet' type='text/css'>
<link href='/allsites/style/iphone4-portrait.css' rel='stylesheet' type='text/css'>
<style>
.show_img { width: 320px;}#{image}</style></head>
<body><article>#{selection}</article></body></html>"
p "bigcontent",bigcontent
  bigcontent
  end
end