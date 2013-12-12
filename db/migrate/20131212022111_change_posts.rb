class ChangePosts < ActiveRecord::Migration
  def up
     add_column :posts, :title, :string
     add_column :posts, :post_img, :string
  end

  def down
  end
end
