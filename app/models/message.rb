class Message < ActiveRecord::Base
  attr_accessible :content, :from_user, :site_id, :status, :to_user, :types
end
