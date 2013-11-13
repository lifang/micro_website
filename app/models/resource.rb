class Resource < ActiveRecord::Base
  belongs_to :site
   attr_accessible :path_name, :site_id
   validates :path_name,presence:true,uniqueness: { case_sensitive: false }
end
