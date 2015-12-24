Deface::Override.new(
  virtual_path: 'spree/products/_cart_form',
  name: 'add_edit_link_to_product_list_items',
  insert_top: "div#product-variants li",
  partial: 'moneta/shared/edit_buttons/variant',
  disabled: false
)
