Spree::Variant.class_eval do
  include Moneta::AlgoliaSearch::Variant if feature_active?(:algolia_search)

  def option_value_for(option_type)
    ot = case option_type
         when String then Spree::OptionType.find_by_name option_type
         when Spree::OptionType then option_type
         else
           raise(
             ArgumentError,
             "Argument must be an OptionType or String naming an OptionType"
           )
         end
    option_values.detect { |ov| ov.option_type == ot }
  end
end
