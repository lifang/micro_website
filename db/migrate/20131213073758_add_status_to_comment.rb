class AddStatusToComment < ActiveRecord::Migration
  def change
    add_column :replies, :status, :boolean, :default => false   # 评论状态，审核，未审核
    remove_column :posts, :comments_count
  end
end
