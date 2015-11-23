# This migration comes from spree (originally 20150330144639)
class CreateSpreeUserStockLocations < ActiveRecord::Migration
  def change
    create_table :spree_user_stock_locations do |t|
      t.integer :user_id
      t.integer :stock_location_id
      t.timestamps null: true
    end
    add_index :spree_user_stock_locations, :user_id
  end
end
