# This migration comes from spree (originally 20160608180751)
class EnsureStoreOnOrders < ActiveRecord::Migration
  class Store < ActiveRecord::Base
    self.table_name = 'spree_stores'
  end
  class Order < ActiveRecord::Base
    self.table_name = 'spree_orders'
  end
  def up
    default_store = Store.find_by(default: true)
    Order.where(store_id: nil).update_all(store_id: default_store.id)
  end
end
