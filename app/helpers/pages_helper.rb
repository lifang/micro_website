#encoding:utf-8
module PagesHelper
  SITE_PATH = "/public/allsites/%s/"
  def model1_html site,bigimg,imgarr,alinkarr
    
    html="
    <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>#{site.name}首页</title>
<script type='text/javascript' src='/allsites/js/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/template_main.js'></script>

<link href='/allsites/style/template_style.css' rel='stylesheet' type='text/css'>
</head>

<body class='cover_bg' style='background-image: url(#{bigimg});'>
	<article>
         <section class='nav_3'>
              <nav>
                  <ul>
                     <li><a href='#{alinkarr[0]}' class='cover_bg' style='background-image:url(\"#{ get_m1_img imgarr[0]}\");'></a></li>
                     <li><a href='#{alinkarr[1]}' class='cover_bg' style='background-image:url(\"#{ get_m1_img imgarr[1]}\");'></a></li>
                     <li><a href='#{alinkarr[2]}' class='cover_bg' style='background-image:url(\"#{ get_m1_img imgarr[2]}\");'></a></li>
                  </ul>
              </nav>
         </section>
    </article>
</body>
</html>
    "
    html
  end
  def model2_html site,bigimg,imgarr,alinkarr
    liarr =""
    imgarr.each_with_index do |img,index|
      liarr += " <li><a href='#{alinkarr[index]}' class='cover_bg' style='background-image:url(\"#{img}\");'></a></li>
      "
    end

    html="
      <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>#{site.name}首页 </title>
<script type='text/javascript' src='/allsites/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/template_main.js'></script>

<link href='/allsites/style/template_style.css' rel='stylesheet' type='text/css'>
</head>

<body class='cover_bg' style='background-image: url(#{bigimg});'>
	<article>
         <section class='nav_8'>
              <nav>
                  <ul>
                     #{liarr}
                      
                  </ul>
              </nav>
         </section>
    </article>
</body>
</html>
    "
    html
  end
  def sub_page_html title,top_img,imgarr,alinkarr
    li=""
    imgarr.each_with_index do |img,index|
      li+="<li><a href='#{alinkarr[index]}'><img src='#{get_sub_img imgarr[index]}'></a></li>
      "
    end
    section=""
    unless top_img.nil?
      section="<section class='cover_bg title' style='background-image: url(#{ top_img });'></section>"
    end
    html="<!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>#{title}</title>
<script type='text/javascript' src='/allsites/js/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/js/template_main.js'></script>
<script type='text/javascript' src='/allsites/js/jquery.wookmark.js'></script>

<link href='/allsites/style/template_style.css' rel='stylesheet' type='text/css'>
</head>

<body>
	<article>
         #{section}
         <section class='show_pic'>
         	  <ul>
                  #{li}
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
</html>"
    html
  end
  def save_as_index site,content
    site_path = Rails.root.to_s+SITE_PATH%site.root_path
    site_index =site_path + "index.html"
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    FileUtils.rm site_index if File::exist?(site_index)
    File.open(site_index, "wb") do |f|
      f.write(content.html_safe)
    end
  end

  def save_as_sub_page site,path,content
    site_path = Rails.root.to_s+SITE_PATH%site.root_path
    FileUtils.mkdir_p(site_path) unless Dir.exists?(site_path)
    FileUtils.rm path if File::exist?(path)
    File.open(path, "wb") do |f|
      f.write(content.html_safe)
    end
  end

  def get_m1_img filename
    filename.split(".")[0...-1].join(".")+"_m1."+filename.split(".")[-1]
  end
  def get_sub_img filename
    filename.split(".")[0...-1].join(".")+"_sub."+filename.split(".")[-1]
  end

  def page_html_deal page_html
    page_html =page_html.gsub(/\|\|/,";");
    raw page_html
  end
  
end
