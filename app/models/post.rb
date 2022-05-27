class Post < ApplicationRecord
  belongs_to :creator, class_name: "User" 
  belongs_to :post_element, polymorphic: true
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :comments
end
