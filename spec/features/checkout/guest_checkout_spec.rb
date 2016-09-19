require "rails_helper"
require "support/capybara_helper"

feature "Guest checkout" do
  let!(:store) { create(:store) }
  let!(:country) { create(:country, states_required: true) }
  let!(:state) { create(:state, country: country) }
  let!(:shipping_method) { create(:shipping_method, name: "Shipping Method 1") }
  let!(:product) { create(:product, name: "Example Product", slug: "example_product") }
  let!(:payment_method) { create(:credit_card_payment_method, name: "Payment Method 1") }

  before do
    Spree::Config.company = true
  end

  scenario "purchase a product", js: true do
    # TODO: start this test with a pre-loaded cart, test add-to-cart separately
    visit "/products/example_product"
    page.click_button("Add To Cart")

    # Default Solidus goes directly to cart on add, but often we'll want to
    # add to cart with AJAX, then visit the cart as a separate step
    visit "/cart"
    expect(page).to have_content("Shopping Cart")

    # TODO: Specify that this should eb a line item
    expect(page).to have_content("Example Product")

    # TODO: Modify quantity, remove item
    page.click_button("Checkout")
    expect(page).to have_content("Registration")
    within "#guest_checkout" do
      fill_in("Email", with: "guest@example.com")
      click_button "Continue"
    end

    expect(page).to have_content("Checkout")
    within "#billing" do
      fill_in("First Name", with: "Test")
      fill_in("Last Name", with: "Test")
      fill_in("Street Address", with: "13820 NE Airport Way")
      fill_in("City", with: "Portland")
      select "United States of America", from: "order_bill_address_attributes_country_id"
      select "Alabama", from: "order_bill_address_attributes_state_id"
      fill_in("Zip", with: "97206")
      fill_in("Phone", with: "12345")
    end
    within "#shipping" do
      check "order_use_billing"
    end
    click_button("Save and Continue")

    expect(page).to have_content("package from NY Warehouse".upcase)
    within "#methods" do
      choose "Shipping Method 1"
    end
    click_button("Save and Continue")

    expect(page).to have_content("Payment Information".upcase)
    within "#payment" do
      choose "Payment Method 1"
      fill_in("Name on card", with: "Test Test")
      fill_in("Card Number", with: "4111111111111111")
      fill_in("Expiration", with: "01/99")
      fill_in("Card Code", with: "123")
    end
    click_button("Save and Continue")

    expect(page).to have_content("Confirm".upcase)
    click_button("Place Order")

    expect(page).to have_content("Your order has been processed successfully")
  end
end
