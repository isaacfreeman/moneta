require "rails_helper"
require "support/solidus_helper"

# TODO: Webmock for image download

describe Import::VariantImporter do
  let(:basic_attributes) do
    {
      cost_price: 5.00,
      depth: 0.2,
      height: 2.4,
      options: "color:red,size:large",
      price: 10.00,
      product_sku: "SKU-001",
      sku: "SKU-001-a",
      weight: 0.8,
      width: 1.2
    }
  end
  let(:attributes_with_stock) { basic_attributes.merge(stock: 19) }
  let(:attributes_with_images) do
    basic_attributes.merge(
      images: "https://upload.wikimedia.org/wikipedia/commons/8/8b/Nestor_notabilis_-Mount_Aspiring_National_Park%2C_New_Zealand-8.jpg,https://upload.wikimedia.org/wikipedia/commons/3/39/Kaka_%28Nestor_meridionalis%29-_Wellington_-NZ-8.jpg"
    )
  end
  let(:attributes_with_unavailable_image) do
    basic_attributes.merge(
      images: "http://example.com/no_such_image.png"
    )
  end
  let(:spree_product) do
    FactoryGirl.create(:product, sku: basic_attributes[:product_sku])
  end

  describe "#import" do
    context "Basic Variant" do
      subject { Import::VariantImporter.new(spree_product, basic_attributes) }
      context "Variant doesn't exist yet" do
        before { @spree_variant = subject.import }
        it "builds the variant" do
          expect(Spree::Variant.where(is_master: false).count).to eq 1
          expect(@spree_variant).to be_valid
        end
      end
      context "Variant exists" do
        before { @spree_variant = subject.import }
        it "updates the existing variant" do
          expect(Spree::Variant.where(is_master: false).count).to eq 1
          expect(@spree_variant).to be_valid
        end
      end
      context "Parent product doesn't exist yet" do
        subject { Import::VariantImporter.new(nil, basic_attributes) }
        it "fails gracefully" do
          expect { subject.import }.to raise_error
        end
      end
    end

    context "Stock" do
      let!(:default_stock_location) do
        FactoryGirl.create :stock_location, default: true
      end
      subject do
        Import::VariantImporter.new(spree_product, attributes_with_stock)
      end
      before { @spree_variant = subject.import }
      it "sets stock" do
        expect(
          default_stock_location.count_on_hand(@spree_variant)
        ).to eq 19
      end
    end

    context "Images" do
      context "available image" do
        subject do
          Import::VariantImporter.new(spree_product, attributes_with_images)
        end
        before { @spree_variant = subject.import }
        it "adds images" do
          expect(@spree_variant.images.count).to eq 2
          expect(
            @spree_variant.images.first.attachment_file_name
          ).to eq "Nestor_notabilis_-Mount_Aspiring_National_Park_2C_New_Zealand-8.jpg"
        end
      end
      context "404 retrieving image" do
        subject { Import::VariantImporter.new(attributes_with_unavailable_image) }
        it "fails gracefully" do
          expect { subject.import }.to raise_error
        end
      end
    end
  end
end
