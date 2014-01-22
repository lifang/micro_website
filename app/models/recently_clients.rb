class RecentlyClients < ActiveRecord::Base
  attr_accessible :client_id, :content, :site_id
end
