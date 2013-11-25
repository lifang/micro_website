#encoding: utf-8
module ApplicationHelper

  def if_authenticate(page)
    page && page.authenticate ? "是" : "否"
  end

  def page_file_name(page)
    page.main? ? "index" : "style.css"
  end

  def page_title(page)
    page.main? ? "index" : "style.css"
  end

  #拼凑form element 对应关系hash
  def form_ele_hash(params_form)
    ele_hash = {}
    params_form.each do |key, value|
      if key.include?("_value")
        name = key.gsub("_value", "")
        ele_hash[name] = value
      end
    end
    ele_hash
  end

  def modifyContent(page,content,site_id,img="")
    content = content.strip
    if page.form? 
      content = "<!DOCTYPE html>
                 <html>
                  <head>
                    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
                    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />
                    <link href='/allsites/form_style.css?body=1' media='all' rel='stylesheet' type='text/css'></link>
<script src='/assets/jquery.js?body=1' type='text/javascript'></script>
<script src='/assets/form.js?body=1' type='text/javascript'></script>
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
//alert('error')
            }
        })
</script>
                    <title>preview</title>
                  </head>
                  <body>
<article>
<div class='r_img_box_1'>#{img}</div>
<div class='r_joinUs2_info'>
                 <form accept-charset='UTF-8' action='/sites/#{site_id}/pages/#{page.id}/submit_queries' class='submit_form_static' method='post'>
                   <div style=\"margin:0;padding:0;display:inline\">
<input name=\"utf8\" type=\"hidden\" value=\"✓\">
<input class='authenticity_token' name=\"authenticity_token\" type=\"hidden\" value=''></div>                 
<span class='delimeter'></span>
                    #{content}
<span class='delimeter'></span>
                   <div class='r_joinUs2_act'><button class='grey_btn' type='button' onclick=\"return submit_form(this,'/sites/#{site_id}/pages/#{page.id}/submit_queries' )\">确认提交</button></div>
</form>
</div>
<div class='second_box' id='form_view'>
  <div class='second_content second_content_3'>
   <span class='second_dtl' id='the_content'>#{page.title}不能为空</span>
   <div class='second_box_act' id='form_view_btn'>
    <a href='' ><span class='r_sure' >确认</span></a>
   </div>
  </div>
 </div>
</article>
</body>
</html>"
    end
    #TODO正则中文有问题
    content = content.gsub(/<title>.*<\/title>/, "<title>#{page.title}</title>")
    content
  end
  
end
