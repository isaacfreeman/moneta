Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_edit_link_to_product_images',
  insert_top: "#main-image",
  partial: 'spree/shared/edit_buttons/image',
  disabled: false
)
