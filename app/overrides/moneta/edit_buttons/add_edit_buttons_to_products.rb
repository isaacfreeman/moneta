Deface::Override.new(
  virtual_path: 'spree/shared/_products',
  name: 'add_edit_link_to_product_list_items',
  insert_top: "[data-hook='products_list_item']",
  partial: 'spree/shared/edit_buttons/product',
  disabled: false
)
Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_edit_link_to_product_pages',
  insert_top: "[data-hook='product_show']",
  partial: 'spree/shared/edit_buttons/product',
  disabled: false
)
