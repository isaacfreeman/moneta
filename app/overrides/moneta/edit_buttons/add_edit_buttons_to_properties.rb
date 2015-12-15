Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_edit_link_to_properties',
  insert_top: "[data-hook='product_properties']",
  partial: 'spree/shared/edit_buttons/properties',
  disabled: false
)
