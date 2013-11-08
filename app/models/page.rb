class Page < ActiveRecord::Base
   attr_accessible :title, :file_name, :types, :site_id, :path_name, :authenticate,:element_relation
end
