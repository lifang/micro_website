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
#{img}
                 <form accept-charset='UTF-8' action='/sites/#{site_id}/pages/#{page.id}/submit_queries' class='submit_form_static' method='post'>
                   <div style=\"margin:0;padding:0;display:inline\">
<input name=\"utf8\" type=\"hidden\" value=\"✓\">
<input class='authenticity_token' name=\"authenticity_token\" type=\"hidden\" value=''></div>
                   <div id='formContent'>
                    #{content}
                   </div><button type='button' onclick='return submit_form(this)'>提交</button></form>
                  </body></html>"
      
    end
    #TODO正则中文有问题
    content = content.gsub(/<title>.*<\/title>/, "<title>#{page.title}</title>")
    content
  end
  
end
