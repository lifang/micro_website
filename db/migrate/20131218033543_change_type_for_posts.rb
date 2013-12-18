class ChangeTypeForPosts < ActiveRecord::Migration
  def change
    change_column :posts, :post_content, :text
  end
end
