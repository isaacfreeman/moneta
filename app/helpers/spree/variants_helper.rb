# Helpers for variants
module Spree::VariantsHelper
  def variant_data_tags(variant)
    tags = variant.option_values.map do |ov|
      "data-option-#{ov.option_type_id}='#{ov.name.downcase.gsub(' ', '_')}'"
    end
    tags.join(' ').html_safe
  end
end
