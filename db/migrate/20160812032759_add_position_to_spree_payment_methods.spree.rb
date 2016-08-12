# This migration comes from spree (originally 20160116133604)
class AddPositionToSpreePaymentMethods < ActiveRecord::Migration
  def change
    add_column :spree_payment_methods, :position, :integer, default: 0
  end
end
