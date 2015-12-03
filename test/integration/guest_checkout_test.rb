require "integration_test_helper"

class GuestCheckoutTest < ActionDispatch::IntegrationTest
  setup do
    FactoryGirl.create(
      :product,
      name: 'Example Product',
      slug: 'example_product'
    )
  end

  teardown do
  end

  test "purchase a product" do
    # TODO: move adding to cart to a separate test that covers other product
    #       page stuff, and start this test with a pre-loaded cart
    visit "/products/example_product"
    assert page.has_content? 'Example Product'
    page.click_button('Add To Cart')

    # Default Solidus goes directly to cart on add, but often we'll want to
    # add to cart with AJAX, then visit the cart as a separate step
    visit "/cart"
    assert page.has_content?  'Shopping Cart'
    assert find('#line_items').has_content? 'Example Product'
    # TODO: Modify quantity, remove item

    page.click_button('Checkout')
    assert page.has_content?  'Registration'
    within '#guest_checkout' do
      fill_in('Email', with: 'guest@example.com')
      click_button 'Continue'
    end

    assert page.has_content?  'Checkout'
    within '#billing' do
      fill_in('First Name', with: 'Test')
      fill_in('Last Name', with: 'Test')
      fill_in('Street Address', with: '13820 NE Airport Way')
      fill_in('City', with: 'Portland')
      select 'United States of America', from: 'order_bill_address_attributes_country_id'
      binding.pry
      select 'Oregon', from: 'order_bill_address_attributes_state_id'
      fill_in('Zip', with: '97206')
      fill_in('Phone', with: '12345')
    end
    within '#billing' do
      check 'order_use_billing'
    end
    click_button('Save and Continue')


  end

end
