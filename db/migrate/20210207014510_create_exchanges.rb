class CreateExchanges < ActiveRecord::Migration[6.0]
  def change
    create_table :exchanges do |t|
      t.string :name, limit: 100, null: false
      t.boolean :is_active, default: true

      t.timestamps
    end
    add_index :exchanges, :name, unique: true
  end
end
