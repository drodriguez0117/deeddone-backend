class CreateListingTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :listing_types do |t|
      t.string :name
      t.text :description
      t.boolean :is_active

      t.timestamps
    end
  end
end
