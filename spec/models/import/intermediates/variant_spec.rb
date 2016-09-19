require "rails_helper"
require "support/solidus_helper"

describe Import::Intermediates::Variant do
  let(:attributes) do
    {
      sku: "SKU-001-a",
      product_sku: "SKU-001",
      options: "color:red,size:large",
      price: 10.00,
      cost_price: 5.00,
      stock: 19,
      width: 1.2,
      height: 2.4,
      depth: 0.2,
      weight: 0.8,
      images: "https://example.com/clothing/t-shirt-front.jpg,https://example.com/clothing/t-shirt-back.jpg"
    }
  end
  describe "#to_spree_attributes" do
    let!(:spree_product) { FactoryGirl.create(:product, sku: "SKU-001") }
    subject { Import::Intermediates::Variant.from_csv_attributes(attributes) }
    it "can build a valid variant" do
      spree_variant = spree_product.variants.new(
        subject.to_spree_attributes(spree_product)
      )
      expect(spree_variant).to be_valid
      expect(
        spree_variant.product.option_types.map(&:name)
      ).to eq %w(color size)
      expect(
        spree_variant.option_values.map(&:name)
      ).to eq %w(red large)
    end
  end
end
