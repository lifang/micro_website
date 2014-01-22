class Remind < ActiveRecord::Base
  attr_accessible :content, :range, :reseve_time, :site_id, :title
end
