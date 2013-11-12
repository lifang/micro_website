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
end
