class ImageAttachedPost < ApplicationRecord
  has_one_attached :image
  has_one :post, as: :post_element
  has_one :creator, class_name: "User", through: :posts
end
