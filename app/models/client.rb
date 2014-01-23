class Client < ActiveRecord::Base
  belongs_to :site
  attr_accessible :avatar_url, :has_new_message, :has_new_record, :html_content, :mobiephone, :name, :password, :site_id, :types, :username
  TYPE = {:master => 0, :client => 1}
  #types: 0 => 站长, 1 =>顾客

end
