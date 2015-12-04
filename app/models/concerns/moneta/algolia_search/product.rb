module Moneta::AlgoliaSearch::Product
  extend ActiveSupport::Concern

  included do
    include ::AlgoliaSearch
    algoliasearch unless: :deleted?, index_name: Rails.configuration.algolia_index do
      add_attribute :categories,
                    :main_image_url,
                    :description,
                    :option_values,
                    :sku,
                    :variant_skus,
                    :variant_hash,
                    :has_variants?,
                    :can_supply?
    end
    # Remove products from Algolia search index when they're marked as deleted
    alias_method :spree_delete, :delete
  end

  # methods defined here are going to extend the class, not the instance of it
  module ClassMethods
  end

  def delete
    spree_delete
    algolia_remove_from_index!
  end

  private

  def categories
    names = []
    taxons.each do |t|
      names << t.name
      t.ancestors.each do |a|
        names << a.name
      end
    end
    names.uniq - ['Menu']
  end

  def main_image_url
    url = ""
    if !images.empty?
      url = images.first.attachment.url
    elsif variant_images.any?
      url = variant_images.first.attachment.url
    end
    url
  end

  def option_values
    option_values = []

    variants.each do |v|
      v.option_values.each do |ov|
        option_values << ov.presentation
      end
    end

    option_values.uniq
  end

  def variant_skus
    if has_variants?
      variants_including_master.collect { |v| v.sku }.compact
    else
      sku
    end
  end

  # TODO: title is being kept for backwards compatibility with Production. It
  #       can be removed once production is using separate name and options.
  def variant_hash
    result = []
    variants_to_use = has_variants? ? variants : [master]
    variants_to_use.each do |v|
      v.prices.each(&:reload)
      options_list = ""
      if option_values.any?
        begin
          options_list = v.options_text
        rescue
          puts '>> options list failed' # some products appear to get this
        end
      end

      option_list_text = options_list.present? ? " (#{options_list})" : ""
      result << {
        'sku' => v.sku,
        'title' => "#{v.product.name}#{option_list_text}",
        'name' => v.product.name,
        'options' => v.option_values.any? ? v.options_text : '',
        'disabled' => !v.in_stock?,
        'stock_on_hand' => v.total_on_hand.to_s,
        'id' => v.id,
        'price' => v.display_price.to_s
      }
    end
    result
  end

  # TODO: Check whether there's a built-in Spree method for this
  def can_supply?
    if has_variants?
      variants.any?(&:in_stock?)
    else
      master.in_stock?
    end
  end

end
