class Award < ActiveRecord::Base
  attr_accessible :begin_date, :end_date, :name, :no_operation_number, :total_number
  belongs_to :site
  has_many :award_infos, dependent: :destroy
  TYPES={ggl:0,qr_code:1}
 # scope :qr_code_awards,{ condition:"types = 1" }
  #scope :weixin_awards,{ condition:"types = 1" }
  
  scope :ggl,{ conditions:"types = 0" } #刮刮乐
  scope :qr_code,{ conditions:"types = 1" } #二维码

end
