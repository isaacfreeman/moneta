require 'spec_helper'
require 'support/feature_spec_helper'

feature 'Guest checkout' do
  let(:product) do
    create(:product, name: 'Example Product', slug: 'example_product')
  end
  let(:variant1) { create(:variant, sku: 'V-1', product: product) }
  let(:variant2) { create(:variant, sku: 'V-2', product: product) }
  let(:color_type) { create(:option_type, name: 'Color') }
  let(:color_value1) do
    create(
      :option_value,
      name: 'red',
      presentation: 'Red',
      option_type: color_type
    )
  end
  let(:color_value2) do
    create(
      :option_value,
      name: 'green',
      presentation: 'Green',
      option_type: color_type
    )
  end

  before :each do
    product.option_types << color_type
    variant1.option_values << color_value1
    variant2.option_values << color_value2
    variant1.stock_items.first.set_count_on_hand(1000)
    variant2.stock_items.first.set_count_on_hand(1000)
    product.variants << [variant1, variant2]
  end
  context 'product without variants' do
    scenario 'visit page and add to cart', js: true do
      visit '/products/example_product'
      expect(page).to have_content('Example Product')
      within '#product-variants' do
        choose 'Size: Green'
      end
      page.click_button('Add To Cart')

      visit '/cart'
      expect(find('#line_items')).to have_content('Example Product')
      expect(find('#line_items')).to have_content('Size: Green')
    end
  end
end
