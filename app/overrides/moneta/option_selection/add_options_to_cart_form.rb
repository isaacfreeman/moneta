# Insert the option controls
Deface::Override.new(
  virtual_path: "spree/products/_cart_form",
  name: "add_options_to_cart_form",
  insert_bottom: "div#product-variants",
  partial: "moneta/shared/option_selection/options",
  disabled: false
)

# Element to show if there's no variant that matches the currently selected options
Deface::Override.new(
  virtual_path: "spree/products/_cart_form",
  name: "add_not_available_to_cart_form",
  insert_before: "div.add-to-cart",
  partial: "moneta/shared/option_selection/not_available",
  disabled: false
)

# Replace variant list items with ones that can be selected by the controls
# TODO: The only change here is to add some data attributes to the opening <li>
#       tag. We don't really want to override the content of the list item.
Deface::Override.new(
  virtual_path: "spree/products/_cart_form",
  name: "add_data_tags_to_variants",
  replace: "#product-variants ul li",
  partial: "moneta/shared/option_selection/variant",
  disabled: false
)
