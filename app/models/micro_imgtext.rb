class MicroImgtext < ActiveRecord::Base
  belongs_to :micro_message
  attr_accessible :content, :img_path, :micro_message_id, :title, :url
end
