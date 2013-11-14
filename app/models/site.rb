class Site < ActiveRecord::Base
  has_many :resources ,dependent: :destroy
  has_many :pages ,dependent: :destroy
  belongs_to :user
  attr_accessible :name, :root_path, :notes, :user_id
  validates :name ,presence:true,uniqueness: { case_sensitive: false },
    uniqueness: { case_sensitive: false }
  validates :root_path ,
   presence:true,
   uniqueness: { case_sensitive: false },
   format:{with:/[a-zA-Z]/i}
end
