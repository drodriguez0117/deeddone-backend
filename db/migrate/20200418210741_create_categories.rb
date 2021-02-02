class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string  :name, limit: 200, null: false
      t.string  :default_image_path, limit: 500
      t.boolean :is_active, default: true
    end
    add_index :categories, :name, unique: true
  end
end
