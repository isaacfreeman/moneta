require "rails_helper"
require "support/capybara_helper"

feature "Guest checkout" do
  let!(:store) { create(:store) }
  let(:product) do
    create(:product, name: "Example Product", slug: "example_product")
  end
  let(:variant1) { create(:variant, sku: "V-1", product: product, option_values: [color_value1, size_value1]) }
  let(:variant2) { create(:variant, sku: "V-2", product: product, option_values: [color_value2, size_value2]) }
  let(:color_type) { create(:option_type, name: "color", presentation: "Color") }
  let(:color_value1) do
    create(
      :option_value,
      name: "red",
      presentation: "Red",
      option_type: color_type
    )
  end
  let(:color_value2) do
    create(
      :option_value,
      name: "green",
      presentation: "Green",
      option_type: color_type
    )
  end
  let(:size_type) { create(:option_type, name: "size", presentation: "Size") }
  let(:size_value1) do
    create(
      :option_value,
      name: "S",
      presentation: "Small",
      option_type: size_type
    )
  end
  let(:size_value2) do
    create(
      :option_value,
      name: "XL",
      presentation: "Extra Large",
      option_type: size_type
    )
  end

  before :each do
    product.option_types << color_type
    product.option_types << size_type
    variant1.stock_items.first.set_count_on_hand(1000)
    variant2.stock_items.first.set_count_on_hand(1000)
    product.variants << [variant1, variant2]
  end
  context "product with variants" do
    scenario "visit page and add to cart", js: true do
      visit "/products/example_product"
      expect(page).to have_content("Example Product")
      select "Extra Large", from: "Size"
      within ".option_type-color" do
        click_link "Green"
      end
      within "#product-variants" do
        choose "Color: Green, Size: Extra Large"
      end
      page.click_button("Add To Cart")

      visit "/cart"
      expect(find("#line_items")).to have_content("Example Product")
      expect(find("#line_items")).to have_content("Color: Green")
    end
  end
end
