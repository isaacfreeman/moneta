# This migration comes from spree (originally 20160718205341)
class AddPaymentIdIndexToSpreeRefunds < ActiveRecord::Migration
  def change
    add_index(:spree_refunds, :payment_id)
  end
end
