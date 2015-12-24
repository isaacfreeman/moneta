require 'spec_helper'
require 'support/feature_spec_helper'

feature 'Guest checkout' do
  before :each do
    create(:product, name: 'Example Product', slug: 'example_product')
  end
  context 'product without variants' do
    scenario 'visit page and add to cart', js: true do
      visit '/products/example_product'
      expect(page).to have_content('Example Product')
      binding.pry
      page.click_button('Add To Cart')

      visit '/cart'
      expect(page).to have_content('Shopping Cart')
      expect(find('#line_items')).to have_content('Example Product')
    end
  end
end