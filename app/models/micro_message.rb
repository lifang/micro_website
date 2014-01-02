class MicroMessage < ActiveRecord::Base
  belongs_to :site
  belongs_to :micro_message
  attr_accessible :content, :img_path, :mtype, :site_id, :title, :url
end
