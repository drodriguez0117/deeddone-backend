class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.string :title
      t.string :description
      t.integer :listing_type_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
