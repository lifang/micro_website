class AddHeadImageUrlToClients < ActiveRecord::Migration
  def change
    add_column :clients, :head_image_url, :string
  end
end
