class UserAward < ActiveRecord::Base
  attr_accessible :award_info_id, :open_id, :award_id, :secret_code, :if_checked
  belongs_to :award_info
end
