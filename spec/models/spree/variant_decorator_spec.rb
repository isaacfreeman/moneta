require "rails_helper"
require "support/solidus_helper"

describe Spree::Variant do
  describe "#option_value_for" do
    subject { FactoryGirl.build(:variant) }
    let(:option_value) { subject.option_values.first }
    let(:option_type) { option_value.option_type }
    it "returns variant's option_value for a given_option_type" do
      expect(subject.option_value_for(option_type)).to eq option_value
    end
    it "accepts a string naming the option_type" do
      expect(subject.option_value_for(option_type.name)).to eq option_value
    end
    it "raises an error if argument has any other class" do
      expect { subject.option_value_for(100) }.to raise_error(
        ArgumentError,
        "Argument must be an OptionType or String naming an OptionType"
      )
    end
  end
end
