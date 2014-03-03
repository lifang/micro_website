class AwardInfo < ActiveRecord::Base
  attr_accessible :award_id, :content, :name, :number, :img, :award_index, :code
  belongs_to :award
  has_many :user_awards
  require "fileutils"
  serialize :code

  SITE_PATH_C =  Rails.root.to_s + "/public/allsites/%s/"

  def generate_image(site_name)
    begin
      file_path = Rails.root.to_s  + "/app/assets/images/jiang_blank.png"   #空白图片
      award_path = "#{SITE_PATH_C % site_name}" + "awards/"
      img = MiniMagick::Image.open file_path,"wb"

      img.combine_options do |c|
        c.gravity 'center'
        c.pointsize "24"
        c.font ("/usr/share/fonts/xpfonts/MSYHBD.TTF")
        c.encoding "utf-8"
        c.fill "#ff0084"
        c.draw "text 0,0 '#{self.name}'"
      end
      FileUtils.mkdir_p(award_path) unless Dir.exists?(award_path)
      img.write("#{award_path}" + "#{self.id}.png")
      return "/allsites/%s/" % site_name + "awards/#{self.id}.png"
    rescue
      return false
    end
  end
end
