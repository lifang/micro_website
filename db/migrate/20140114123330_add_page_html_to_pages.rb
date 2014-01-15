class AddPageHtmlToPages < ActiveRecord::Migration
  def change
    add_column :pages, :page_html, :text  #存储首页或者子页的模版html页面
  end
end
