class CreateImageAttachedPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :image_attached_posts do |t|

      t.timestamps
    end
  end
end
