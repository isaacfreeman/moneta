require "rails_helper"
require "support/solidus_helper"

describe Import::Intermediates::Product do
  let(:attributes) do
    {
      sku: "SKU-001",
      name: "T-Shirt",
      description: "An example product",
      available_on: "2011-02-14",
      meta_title: "Meta Title",
      meta_description: "Meta Description",
      meta_keywords: "Meta Keywords",
      tax_category: "default",
      shipping_category: "default",
      price: 10.0,
      cost_price: 5.0,
      stock: 10,
      width: 1.2,
      height: 2.4,
      depth: 0.2,
      weight: 0.8,
      properties: "{\"material\":\"cotton\",\"neck\":\"vee\"}",
      taxons: "Clothing,Clothing>Shirts,Brand>ACME Products International",
      images: "https://example.com/clothing/t-shirt-front.jpg,https://example.com/clothing/t-shirt-back.jpg"
    }
  end
  describe "#to_spree_attributes" do
    subject { Import::Intermediates::Product.from_csv_attributes(attributes) }
    it "can build a valid product" do
      spree_product = Spree::Product.new(subject.to_spree_attributes)
      expect(spree_product).to be_valid
    end
  end
end
