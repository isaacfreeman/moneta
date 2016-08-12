# This migration comes from spree (originally 20160229133259)
class AddCartTaxCountryIsoToSpreeStore < ActiveRecord::Migration
  def change
    add_column :spree_stores, :cart_tax_country_iso, :string, null: true, default: nil
  end
end
