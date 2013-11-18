# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(:name => "admin", :password => 'admin1234', :email => "admin@microwebsite.com")
user.status = User::TYPES[:admin]
user.types = User::STATUS_NAME[:normal]
user.save