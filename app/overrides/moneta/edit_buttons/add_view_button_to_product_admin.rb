Deface::Override.new(
  virtual_path: 'spree/admin/products/edit',
  name: 'add_view_link_to_product_admin_pages',
  insert_after: "erb:contains('content_for :page_actions')",
  partial: 'spree/shared/view_buttons/product',
  disabled: false
)
