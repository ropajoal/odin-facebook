class AddPostElementToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :post_element_id, :integer
    add_column :posts, :post_element_type, :string
    remove_column :posts, :title
    remove_column :posts, :content
  end
end
