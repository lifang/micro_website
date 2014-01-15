#encoding:utf-8
module PagesHelper
  def model1_html site,bigimg,imgarr
    html="
    <!doctype html>
<html>
<head>
<meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no'>
<title>#{site.name}首页</title>
<script type='text/javascript' src='/assets/jQuery-v1.9.0.js'></script>
<script type='text/javascript' src='/allsites/template_main.js'></script>

<link href='/allsites/template_style.css' rel='stylesheet' type='text/css'>
</head>

<body class='cover_bg' style='background-image: url(#{bigimg});'>
	<article>
         <section class='nav_3'>
              <nav>
                  <ul>
                     <li><a href='#' class='cover_bg' style='background-image:url(images/186-3.png);'></a></li>
                     <li><a href='#' class='cover_bg' style='background-image:url(images/186-3.png);'></a></li>
                     <li><a href='#' class='cover_bg' style='background-image:url(images/186-3.png);'></a></li>
                  </ul>
              </nav>
         </section>
    </article>
</body>
</html>
    "
  end
end
