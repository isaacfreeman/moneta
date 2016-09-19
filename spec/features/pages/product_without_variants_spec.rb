require "rails_helper"
require "support/capybara_helper"

feature "Guest checkout" do
  let!(:store) { create(:store) }
  let(:product) { create(:product, name: "Example Product", slug: "example_product") }
  context "product without variants" do
    scenario "visit page and add to cart", type: :feature, js: true do
      visit spree.product_path(product)
      expect(page).to have_content("Example Product")
      click_button("Add To Cart")

      # visit "/cart"
      expect(page).to have_content("Shopping Cart")
      expect(find("#line_items")).to have_content("Example Product")
    end
  end
end
