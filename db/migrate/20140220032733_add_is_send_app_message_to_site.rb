class AddIsSendAppMessageToSite < ActiveRecord::Migration
  def change
    add_column :sites , :is_send_app_msg ,:boolean
  end
end
