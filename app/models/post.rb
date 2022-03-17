class Post < ApplicationRecord
  belongs_to :creator, class_name: "User" 
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
end
