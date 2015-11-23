# This migration comes from spree (originally 20150506182045)
class CreateStoreCreditReimbursementType < ActiveRecord::Migration
  def up
    Spree::ReimbursementType.create_with(name: Spree.t("store_credit.store_credit")).find_or_create_by!(type: 'Spree::ReimbursementType::StoreCredit')
  end
end
