require "rails_helper"
describe MonetaHelper, type: :helper do
  describe "#moneta_body_class" do
    before do
      allow(helper.controller).to(
        receive(:controller_path).and_return("spree/products")
      )
      allow(helper.controller).to(
        receive(:action_name).and_return("show")
      )
    end

    it "includes controller and action" do
      expect(helper.moneta_body_class).to(
        eq("spree-products spree-products-show")
      )
    end

    it "includes additional classes provided via content_for" do
      allow(helper).to receive(:content_for).and_return("foo")
      allow(helper).to receive(:content_for?).and_return(true)
      expect(helper.moneta_body_class).to(
        eq("spree-products spree-products-show foo")
      )
    end
  end
end
