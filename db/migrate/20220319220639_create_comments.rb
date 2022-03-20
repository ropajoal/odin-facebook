class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.references :post, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
