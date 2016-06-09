module Spree
  module Reports
    class OutOfStockVariants
      include ActionView::Helpers::UrlHelper

      def self.metadata
        {
          title: "Out of Stock Variants Report",
          description: "Items that are out of stock"
        }
      end

      def initialize(params)
        @page = params[:page]
        now = Time.zone.now
        today = Time.zone.today
        start_date = params[:start_date] || today.at_beginning_of_month.to_s.tr("-", "/")
        end_date = params[:end_date] || today.at_end_of_month.to_s.tr("-", "/")
        @start_time = !start_date.blank? ? parse_date_param(start_date) : (now - 2.days)
        @end_time = !end_date.blank? ? parse_date_param(end_date) : now
      end

      def headers
        [
          { sku: "SKU" },
          { product_link: "Product" },
          { variant_link: "Variant" }
        ]
      end

      def rows(paginated: true)
        variants = Spree::Variant
          .includes(:option_values)
          .joins([:product, :stock_items])
          .where('spree_variants.track_inventory IS TRUE')
          .group('spree_variants.id')
          .having('SUM(spree_stock_items.count_on_hand)=0')
          .group('spree_products.name')
          .order('spree_products.name asc')
        # Not sure how to do this in SQL
        variants = variants
                   .reject { |v| v.is_master? && v.product.has_variants? }

        rows = variants.map { |variant| row(variant) }
        rows = Kaminari.paginate_array(rows).page(@page).per(100) if paginated
        rows
      end

      def template
        "spree/admin/reports/report"
      end

      def csv_filename
      end

      def locals
        {
          start_time: @start_time,
          end_time: @end_time
        }
      end

      def summary_data
        {}
      end

      private

      def row(variant)
        product = variant.product
        sku = variant.is_master? ? variant.sku : product.sku
        product_link = link_to(product.name, Spree::Core::Engine.routes.url_helpers.edit_admin_product_path(product))
        variant_link = variant.is_master? ? nil : link_to(variant.options_text, Spree::Core::Engine.routes.url_helpers.edit_admin_product_variant_path(product, variant))
        {
          sku: sku,
          product_link: product_link,
          variant_link: variant_link
        }
      end

      def parse_date_param(datestr)
        Time.zone.parse(datestr)
      end
    end
  end
end
