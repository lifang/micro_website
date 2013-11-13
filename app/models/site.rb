<<<<<<< HEAD
class Site < ActiveRecord::Base
  has_many :resources
  has_many :pages
  attr_accessible :name, :root_path, :notes, :user_id
  validates :name ,presence:true,uniqueness: { case_sensitive: false }
  validates :root_path ,
   presence:true,
   uniqueness: { case_sensitive: false },
   format:{with:/[a-zA-Z]/i}
end
=======
class Site < ActiveRecord::Base
  has_many :pages
  attr_accessible :name, :root_path, :notes, :user_id
  validates :name ,presence:true,uniqueness: { case_sensitive: false }
  validates :root_path ,
   presence:true,
   uniqueness: { case_sensitive: false },
   format:{with:/[a-zA-Z]/i}
end
>>>>>>> 48503c02396c467b27a369a4a75b461ac4243441
