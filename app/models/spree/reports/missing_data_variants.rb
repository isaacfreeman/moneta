module Spree
  module Reports
    class MissingDataVariants
      include ActionView::Helpers::UrlHelper

      def self.metadata
        {
          title: "Missing Data Variants Report",
          description: "Items with missing data"
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
          { variant_link: "Variant" },
          { weight: "Weight" },
          { height: "Height" },
          { width: "Width" },
          { depth: "Depth" }
        ]
      end

      def rows(paginated: true)
        missing_data_query_string = 'weight IS NULL OR weight = 0 OR height IS NULL OR height = 0 OR width IS NULL OR width = 0 OR depth IS NULL OR depth = 0'
        variants = Spree::Variant
          .includes(:product)
          .joins(:product)
          .active
          .where(missing_data_query_string)
          .where('spree_products.deleted_at is null')

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
          variant_link: variant_link,
          weight: variant.weight || "?",
          height: variant.height || "?",
          width: variant.width || "?",
          depth: variant.depth || "?"
        }
      end

      def parse_date_param(datestr)
        Time.zone.parse(datestr)
      end
    end
  end
end
