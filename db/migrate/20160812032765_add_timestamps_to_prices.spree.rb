# This migration comes from spree (originally 20160318145302)
class AddTimestampsToPrices < ActiveRecord::Migration
  def change
    change_table(:spree_prices) { |t| t.timestamps null: true }
  end
end
