module Moneta
  module AlgoliaSearch
    # Index products in Algolia on update
    module Product
      extend ActiveSupport::Concern

      included do
        include ::AlgoliaSearch
        algoliasearch unless: :deleted?, index_name: Rails.configuration.algolia_index do
          add_attribute :can_supply?,
                        :categories,
                        :description,
                        :display_price,
                        :has_variants?,
                        :main_image_url,
                        :option_values,
                        :sku,
                        :variants_hash,
                        :variant_skus
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
        taxons.map do |taxon|
          taxon.self_and_ancestors.map(&:name)
        end.flatten.uniq - ['Categories']
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
        variants.map do |variant|
          variant.option_values.map(&:presentation)
        end.flatten.uniq
      end

      def variant_skus
        if has_variants?
          variants_including_master.collect(&:sku).compact
        else
          sku
        end
      end

      def variants_hash
        variants_to_use = has_variants? ? variants : [master]
        variants_to_use.map do |variant|
          variant.prices.each(&:reload)
          variant.to_algolia_hash
        end
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
  end
end
