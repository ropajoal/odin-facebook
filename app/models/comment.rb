class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :creator, class_name: "User"
end
