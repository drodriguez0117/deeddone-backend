class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.string :title, limit: 30, null: false
      t.string :description, limit: 200
      t.string :listing_type, null: false
      t.boolean :is_active, null: false, default: true
      t.references :user, { null: false, foreign_key: true }
      t.references :category, {null: false, foreign_key: true }
      t.references :exchange, {null: false, foreign_key: true}

      t.timestamps
    end
  end
end
