#encoding:utf-8
class ImageStreamsController < ApplicationController
  require 'will_paginate/array'
  before_filter :get_site
  SITE_PATH = "/public/allsites/%s/"
  PUBLIC_PATH =  Rails.root.to_s + "/public/allsites"
  layout 'sites'
  def new
    @site=Site.find(params[:site_id])
    #@imgs_path=@site.resources
    #@imgs_path =@site.resources.paginate(:page=>params[:page],:per_page=>12,:conditions =>"path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page =>1,:per_page=>12)
    

  end

  def img_stream
    @site=Site.find(params[:site_id])
    @image_stream_pages=@site.pages.image_stream.paginate(page:params[:page]|| 1,:per_page => 10)
    #@imgs_path=@site.resources
  end
  def create_imgtxt
    name=params[:name];
    title=params[:title];
    check=params[:check];
    imgarr=params[:src].split(",");
    textstr=params[:pic_text] ;
    p imgarr,textstr
    @site=Site.find(params[:site_id]);
    @page=@site.pages.build
    @page.title=title
    @page.file_name=name+".html"
    @page.authenticate=check
    @page.types=5
    @page.path_name="/"+@site.root_path+"/"+name+".html"
    if @page.save
      page_image=@page.page_image_texts.build
      page_image.img_path=imgarr
      page_image.content=textstr
      page_image.save
      bag_img_magick imgarr
      content=get_content(imgarr,textstr)
      bigcontent=get_bigcontent(imgarr,textstr)
      save_in_file(content,bigcontent,@site,@page.file_name)
      render :text=>1
    else
      render :text=>0
    end
  end
  #截取图片
  def bag_img_magick(imgarr)
     #图片      
      imgarr.each do |x|
        filename=x.split("/")[-1]
        dirpath=Rails.root.to_s + "/public#{x.split('/')[0...-1].join('/')}"
        min_image(Rails.root.to_s + "/public#{x}",filename,dirpath)
      end
  end
 #资源全路径,文件名 ,dir
  def min_image(ful_path,filename,ful_dir)
    target_path=ful_dir+"/"+filename.split(".")[0...-1].join(".")+"_min."+filename.split(".")[-1]
    if !File.exist?(target_path)&&which_res(filename)=='img'
    image = MiniMagick::Image.open(ful_path)
    resize = 280 > image["width"] ? image["width"] : 280
    image.resize resize
    image.write  ful_dir+"/"+filename.split(".")[0...-1].join(".")+"_min."+filename.split(".")[-1]
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
  
  def edit
    @page = Page.find(params[:id])
    @image_text =PageImageText.find_by_page_id(params[:id])
    @site=Site.find(params[:site_id])
    @imgs_pathes = @site.resources.where("path_name like '%.jpg' or path_name like '%.gif' or path_name like '%.png' or path_name like '%.jpeg' ")
    @imgs_path = @imgs_pathes.paginate(:page =>1,:per_page=>12)
  end
 
  def edit_update
    name=params[:name]+".html";
    title=params[:title];
    #check=params[:check];
    imgarr=params[:src].split(",");
    textstr=params[:pic_text];
    @site=Site.find(params[:site_id]);
    @page=Page.find(params[:id]);
    @image_text=PageImageText.find_by_page_id(params[:id])
    if @page.update_attributes(file_name:name,title:title)
      @image_text.update_attributes(img_path:imgarr,content:textstr)
      # 删除已经存在的html文件
      bigimg_path=PUBLIC_PATH+"/"+@site.root_path+"/bigimg_"+@page.file_name
      File.delete PUBLIC_PATH + @page.path_name if File.exists?(PUBLIC_PATH + @page.path_name)
      File.delete  bigimg_path if File.exists?(bigimg_path)
      #保存更新完的文件
      bag_img_magick imgarr
      content=get_content(imgarr,textstr)
      bigcontent=get_bigcontent(imgarr,textstr)
      save_in_file(content,bigcontent,@site,@page.file_name)
      render :text=>1
    else
      render :text=>0
    #  redirect_to site_image_texts_path(@site)
   # else
     # render "edit_itpage"
    end
  end
  
  #私有方法|||||||||||||||||||||||||||||||||||||||||||||||---------华丽的分割线----------||||||||||||||||||||||||||||||||||||||||||||||
  private
  #
  def which_res(name)
    @img_resources=%w[jpg png gif jpeg]
    @voice_resources=%w[mp3]
    @video_resoures=%w[mp4 avi rm rmvb]
    name=name.split('.')[-1]
    name.downcase!
    if @img_resources.include?(name)
      return 'img'
    elsif @voice_resources.include?(name)
      return 'voice'
    else @video_resoures.include?(name)
      return 'voide'
    end
  end
  #保存进
  def save_in_file(content,bigcontent,site,fname)
    site_path = Rails.root.to_s + SITE_PATH % site.root_path
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    FileUtils.rm site_path + fname if File::exist?(site_path + fname)
    File.open(site_path + fname, "wb") do |f|
      f.write(content.html_safe)
    end
    FileUtils.rm site_path + "bigimg_"+fname if File::exist?(site_path + "bigimg_"+fname)
    File.open(site_path + "bigimg_"+fname, "wb") do |fb|
      fb.write(bigcontent.html_safe)
    end
  end
  def encoding_character(str)
    arr={"<"=>"&lt;",">"=>"&gt;"}
    str.gsub(/<|>/){|s| arr[s]}
  end
  #得到内容
  def get_content(imgarr,textarr)
    str=""
    (0..imgarr.length-1).each do |x|
      p1=(textarr[x].nil? ? '':"<p>#{encoding_character textarr[x]}</p>")
      #image = MiniMagick::Image.open(Rails.root.to_s + '/public' +deal_img_to_min(imgarr[x]))
      #<li><a href='bigimg_#{@page.file_name}#page-#{x+1}'><img src='#{deal_img_to_min imgarr[x]}' width='140' height='#{image['height']*140/image['width']}' ></a>#{p1}</li>
      str+="<li><a href='bigimg_#{@page.file_name}#page-#{x+1}'><img  src='#{deal_img_to_min imgarr[x]}'></a>#{p1}</li>
      "
    end
    
#html 内容
    content="
    <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>#{@page.title}</title>
<script type='text/javascript' src='/allsites/js/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/jquery.wookmark.js'></script>
<script type='text/javascript' src='/allsites/js/template_main.js'></script>

<link href='/allsites/style/template_style.css' rel='stylesheet' type='text/css'>
</head>

<body>
	<article>
         <section class='show_pic'>
         	  <ul>
                 #{str}
              </ul>
         </section>
    </article>
    " + page_footer(@site)+"
     <script type='text/javascript'>
    	$(function(){
			$('.show_pic ul li').wookmark({
				container:$('.show_pic ul'),
				offset:10,

			});
		})
    </script>
</body>
</html>
    "
    content
  end

  def get_bigcontent(imgarr,textarr)
    #<div class='text'>#{textarr[i-1]}</div>
    selection="";
    image=""
    (1..imgarr.length).each do|i|
      selection+="<section id='page-#{i}' data-role='page' class='demo-page'><div class=\'show_img si_#{i}\'></div></section>"
      image+=".si_#{i} { background: url('#{imgarr[i-1]}') no-repeat; background-size: cover;}
      "
    end
    bigcontent="
    <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>#{@page.title}</title>
<script type='text/javascript' src='/allsites/js/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/jquery.mobile-1.3.2.js'></script>
<script type='text/javascript' src='/allsites/js/template_main.js'></script>

<link href='/allsites/style/jquery.mobile-1.3.2.css' rel='stylesheet' type='text/css'>
<link href='/allsites/style/template_style.css' rel='stylesheet' type='text/css'>
<style  type='text/css'>
#{image}
</style>
</head>
<body>
<article>
  <article>#{selection}</article>
</article>
" + page_footer(@site)+"
</body></html>"
  bigcontent
  end
end