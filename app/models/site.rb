class Site < ActiveRecord::Base
   attr_accessible :name, :root_path, :notes, :user_id
end
