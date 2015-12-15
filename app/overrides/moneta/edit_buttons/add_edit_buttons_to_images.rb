# Deface::Override.new(
#   virtual_path: 'spree/shared/_products',
#   name: 'add_edit_link_to_product_list_items',
#   insert_top: "[data-hook='products_list_item']",
#   partial: 'spree/shared/edit_buttons/product',
#   disabled: true
# )
Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_edit_link_to_product_images',
  insert_top: "#main-image",
  partial: 'spree/shared/edit_buttons/image',
  disabled: false
)
