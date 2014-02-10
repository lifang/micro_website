class CreateSubmitRedirects < ActiveRecord::Migration
  def change  #表单提交后重定向页面   以及  图文模板里面的一键导航，一键拨号，网上报名
    create_table :submit_redirects do |t|
      t.integer :page_id
      t.string :message
      t.string :phone
      t.string :address
      t.integer :form_id

      t.timestamps
    end
  end
end
