class ClientHtmlInfo < ActiveRecord::Base
  attr_accessible :client_id, :hash_content
  serialize :hash_content
end
