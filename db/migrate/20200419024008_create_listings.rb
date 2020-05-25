class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.string :description
      t.references :listing_type, null: false
      t.boolean :is_active, null: false, default: true
      t.references :user, { null: false, foreign_key: true }

      t.timestamps
    end
  end
end
