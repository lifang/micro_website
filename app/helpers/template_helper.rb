#encoding: utf-8
module TemplateHelper
  #初始化 处理模板3需要的图片
  def initial_template3(img_links, img_srcs, ad_srcs)
   
    new_img_srcs = []
    size = ""
    img_srcs.each_with_index do |img_src, index|
      if index >= 0 && index <=3 #中间四张图 150*300，截成300*600
        size = "300_600"
      elsif index > 3 #底下三张图 212*160，截成424*320
        size = "424_320"
      end
      if img_src.present?
        img_full_path = Rails.root.to_s + "/public" + img_src
        new_src = crop_img(img_full_path, size, img_src) if size.present?
        new_img_srcs << (new_src || img_src)
      else
        new_img_srcs << ""
      end
    end
   
    content = generate_template3(img_links, new_img_srcs, ad_srcs)
    content
  end

  #生成模板页面
  def generate_template3(img_links, new_img_srcs, ad_srcs)
    ad_content, ad_num = '', ''
    ad_srcs.each_with_index do |ad_src, index|
      ad_content = ad_content + '<li id="page-' + (index+1).to_s + '" data-role="page" class="demo-page">
                    	<span class="cover_bg" style="background-image: url(' + '\'' + ad_src + '\'' + ')"><a href="#" rel="external"></a></span>
                    </li>'
      if index == 0
        ad_num = ad_num + '<li class="on">' + (index+1).to_s + '</li>'
      else
        ad_num = ad_num + '<li>' + (index+1).to_s + '</li>'
      end
    end

    content = '<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>申邑•微网站</title>
<script type="text/javascript" src="/allsites/js/jQuery-v1.9.0.js"></script>
<script type="text/javascript" src="/allsites/js/jquery.mobile-1.3.2.js"></script>

<link href="/allsites/style/template_style.css" rel="stylesheet" type="text/css">
<link href="/allsites/style/jquery.mobile-1.3.2.css" rel="stylesheet" type="text/css">
</head>

<body style="background: #F6F8F7;">
	<article>
    	<section class="ad">
        	<div class="ad_box">
            	<ul>'+ ad_content +'
                </ul>
            </div>
            <div class="ad_num">
            	<ul> ' + ad_num + '
                </ul>
            </div>
        </section>

        <section class="category">
        	<ul>
            	<li><a href="' + img_links[0] +'"rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[0] + '\'' + '); "></a></li>
                <li><a href="' + img_links[1] +'" rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[1] + '\'' + '); "></a></li>
                <li><a href="' + img_links[2] +'" rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[2] + '\'' + '); "></a></li>
                <li><a href="' + img_links[3] +'" rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[3] + '\'' + '); "></a></li>
            </ul>
        </section>

        <section class="nav_d">
        	<nav>
            	<ul>
                	<li><a href="' + img_links[4] +'" rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[4] + '\'' + '); "></a></li>
                    <li><a href="' + img_links[5] +'" rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[5] + '\'' + '); "></a></li>
                    <li><a href="' + img_links[6] +'" rel="external" class="cover_bg" style="background-image:url(' + '\'' + new_img_srcs[6] + '\'' + '); "></a></li>
                </ul>
            </nav>
        </section>
<script type="text/javascript" src="/allsites/js/template_main.js"></script>
    </article>
</body>
</html>'

    content
  end


  #截图
  def crop_img(img_full_path, size, img_src)
    file_ext_name = File.extname(img_full_path)
    file_base_name = File.basename(img_full_path, file_ext_name)
    file_dir = File.dirname(img_full_path)
    new_file_name = file_base_name + "_" + size + file_ext_name
    new_file = file_dir + "/" + new_file_name
    path_dir = File.dirname(img_src) + "/"
    if File.exist?(new_file)
      return path_dir + new_file_name
    else
      begin
        image = MiniMagick::Image.open(img_full_path)
        width, height = size.split("_").map(&:to_i)
        resize = width > image["width"] ? "#{image['width']}" : "#{width} x #{height}"
        image.resize resize
        image.write new_file
        return path_dir + new_file_name
      rescue
        return ""
      end
    end
 
  end
end