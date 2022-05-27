class CreateTextPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :text_posts do |t|
      t.text :text_content

      t.timestamps
    end
  end
end
