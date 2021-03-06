class MicroMessage < ActiveRecord::Base
  has_many :micro_imgtexts, :dependent => :destroy
  has_one :keyword
  belongs_to :site
  attr_accessible :content, :img_path, :mtype, :site_id, :title, :url 

  TYPE_STR = ["text", "image_text"]
  TYPE = {:text => false, :image_text => true}  #mtype:false代表文字，true代表图文

  TYPE_STR.each do |ts|
    scope ts.to_sym, :conditions => { :mtype => TYPE[ts.to_sym] }
     define_method  "#{ts}?" do
      self.mtype == TYPE[ts.to_sym]
    end
  end
end
