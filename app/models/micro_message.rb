class MicroMessage < ActiveRecord::Base
  attr_accessible :content, :img_path, :mtype, :site_id, :title, :url
end
