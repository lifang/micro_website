class Post < ActiveRecord::Base
  attr_accessible :post_content, :post_status, :site_id
  has_many :replies
end
