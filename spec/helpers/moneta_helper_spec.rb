require "rails_helper"

describe MonetaHelper, type: :helper do
  describe "#moneta_body_class" do
    it "includes controller and action" do
      allow(helper.controller).to receive(:controller_path).and_return("spree/products")
      allow(helper.controller).to receive(:action_name).and_return("show")
      expect(helper.moneta_body_class).to eq('spree-products spree-products-show')
    end
  end
end
