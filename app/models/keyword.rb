class Keyword < ActiveRecord::Base
  belongs_to :site
  has_many :micro_messages
  attr_accessible :keyword, :micro_message_id, :site_id
end
