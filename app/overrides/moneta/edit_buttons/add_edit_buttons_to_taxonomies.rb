Deface::Override.new(
  virtual_path: 'spree/shared/_taxonomies',
  name: 'add_edit_link_to_taxonomies_sidebar',
  insert_bottom: ".taxonomy-root",
  partial: 'moneta/shared/edit_buttons/taxonomy',
  disabled: false,
  original: '57b52d16df2ab9076a521575345b8094ce86b7c9'
)
