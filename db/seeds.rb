# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'json'

NUMBER_USERS = 20 

users = []

JSON.load(URI.open("https://random-data-api.com/api/users/random_user?size=#{NUMBER_USERS}")).each do |user|
  users.push({email: user["email"], username: user["username"].tr('.\'',''), password: user["username"].tr('.\'',''), password_confirmation: user["username"].tr('.\'','')})
end

User.create users


