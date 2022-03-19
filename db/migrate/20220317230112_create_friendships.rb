class CreateFriendships < ActiveRecord::Migration[6.1]
  def change
    create_table :friendships do |t|
      t.references :user1, null: false, foreign_key: {to_table: :users}
      t.references :user2, null: false, foreign_key: {to_table: :users}
      t.string :status

      t.timestamps
    end
  end
end
