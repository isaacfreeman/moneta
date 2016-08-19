Deface::Override.new(
  virtual_path: 'spree/products/_cart_form',
  name: 'add_edit_link_to_option_types',
  insert_top: "[data-hook='option_types']",
  partial: 'moneta/shared/edit_buttons/option_types',
  disabled: false
)
