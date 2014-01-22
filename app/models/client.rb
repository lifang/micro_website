class Client < ActiveRecord::Base
  attr_accessible :avatar_url, :has_new_message, :has_new_record, :html_content, :mobiephone, :name, :password, :site_id, :types, :username
end
