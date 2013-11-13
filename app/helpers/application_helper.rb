#encoding: utf-8
module ApplicationHelper

  def if_authenticate(page)
    page && page.authenticate ? "是" : "否"
  end

  def page_file_name(page)
    page.types == Page::TYPE_NAMES[:main] ? "index.html" : "style.css"
  end

  def page_title(page)
    page.types == Page::TYPE_NAMES[:main] ? "index" : "style.css"
  end

  #拼凑form element 对应关系hash
  def form_ele_hash(params_form)
    p 11111111111111111
    p params_form
    ele_hash = {}
    params_form.each do |key, value|
      if key.include?("_value")
        name = key.gsub("_value", "")
        ele_hash[name] = value
      end
    end
    p 22222222222222
    p ele_hash
    ele_hash
  end
  
end
