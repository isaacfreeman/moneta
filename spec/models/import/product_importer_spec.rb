require "rails_helper"
require "support/solidus_helper"

# TODO: Webmock for image download

describe Import::ProductImporter do
  let(:basic_attributes) do
    {
      available_on: "2011-02-14",
      cost_price: 5.0,
      depth: 0.2,
      description: "An example product",
      height: 2.4,
      meta_description: "Meta Description",
      meta_keywords: "Meta Keywords",
      meta_title: "Meta Title",
      name: "T-Shirt",
      price: 10.0,
      properties: "{\"material\":\"cotton\",\"neck\":\"vee\"}",
      shipping_category: "default",
      sku: "SKU-001",
      tax_category: "default",
      weight: 0.8,
      width: 1.2
    }
  end
  let(:invalid_attributes) { basic_attributes.except(:name) }
  let(:attributes_with_stock) { basic_attributes.merge(stock: 10) }
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
  let(:attributes_with_taxons) do
    basic_attributes.merge(
      taxons: "Clothing,Clothing>Men>Shirts,Brand>ACME Products International"
    )
  end

  describe "#import" do
    context "Basic Product" do
      subject { Import::ProductImporter.new(basic_attributes) }
      context "Product doesn't exist yet" do
        before { @spree_product = subject.import }
        it "builds the product" do
          expect(Spree::Product.count).to eq 1
          expect(@spree_product).to be_valid
        end
      end
      context "Product exists" do
        let!(:product) do
          FactoryGirl.create(
            :product,
            sku: basic_attributes[:sku],
            description: "Old product description"
          )
        end
        before { @spree_product = subject.import }
        it "updates the existing product" do
          expect(Spree::Product.count).to eq 1
          expect(@spree_product).to be_valid
          expect(@spree_product.description).to eq(
            basic_attributes[:description]
          )
        end
      end
      context "Invalid attributes" do
        subject { Import::ProductImporter.new(invalid_attributes) }
        it "Fails gracefully, so we can move on to the next product" do
          expect { subject.import }.to raise_error(
            ActiveRecord::RecordInvalid,
            "Validation failed: Name can't be blank"
          )
        end
      end
    end

    context "Stock" do
      let!(:default_stock_location) do
        FactoryGirl.create :stock_location, default: true
      end
      subject { Import::ProductImporter.new(attributes_with_stock) }
      before { @spree_product = subject.import }
      it "sets stock" do
        expect(
          default_stock_location.count_on_hand(@spree_product.master)
        ).to eq 10
      end
    end

    context "Images" do
      context "available image" do
        subject { Import::ProductImporter.new(attributes_with_images) }
        before { @spree_product = subject.import }
        it "adds images" do
          expect(@spree_product.images.count).to eq 2
          expect(
            @spree_product.images.first.attachment_file_name
          ).to eq(
            "Nestor_notabilis_-Mount_Aspiring_National_Park_2C_New_Zealand-8.jpg"
          )
        end
      end
      context "404 retrieving image" do
        subject do
          Import::ProductImporter.new(attributes_with_unavailable_image)
        end
        it "fails gracefully" do
          expect { subject.import }.to raise_error(
            OpenURI::HTTPError,
            "404 Not Found"
          )
        end
      end
    end

    context "Taxons" do
      subject { Import::ProductImporter.new(attributes_with_taxons) }
      before { @spree_product = subject.import }
      it "imports taxons" do
        expect(Spree::Taxonomy.count).to eq 2
        expect(Spree::Taxon.count).to eq 5
        taxon_pretty_names = @spree_product.taxons.map(&:pretty_name)
        expect(taxon_pretty_names).to eq [
          "Clothing",
          "Clothing -> Men -> Shirts",
          "Brand -> ACME Products International"
        ]
      end
      it "doesn't try to replace taxons if they're already present"
      it "removes existing taxons that aren't specified"
    end
  end
end
