class Reply < ActiveRecord::Base
  attr_accessible :post_id, :reply_content, :send_open_id, :target_open_id
  belongs_to :post, :counter_cache => true
end
