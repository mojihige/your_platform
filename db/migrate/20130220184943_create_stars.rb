class CreateStars < ActiveRecord::Migration[4.2]
  def change
    create_table :stars do |t|
      t.integer :starrable_id
      t.string :starrable_type
      t.integer :user_id

      t.timestamps
    end
  end
end
