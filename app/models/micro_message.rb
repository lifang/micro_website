class MicroMessage < ActiveRecord::Base
  has_many :micro_imgtexts
  belongs_to :site
  attr_accessible :content, :img_path, :mtype, :site_id, :title, :url #mtype:0代表自动回复的东西，1代表文字，2代表图文
end
