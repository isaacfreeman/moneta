if feature_active?(:improved_reports)
  Spree::Admin::ReportsController.class_eval do
    include ActionView::Helpers::AssetUrlHelper
    DATE_FORMAT = "%m/%d/%Y %l:%M %p"

    def initialize
      super
      Spree::Admin::ReportsController.add_available_report!(:sales_total)

      # TODO: Use locales for description
      Rails.application.config.spree.reports.each do |report|
        Spree::Admin::ReportsController.add_available_report!(
          report.name.demodulize.underscore.to_sym,
          report.metadata[:description]
        )
      end
    end

    # Generate a method for each registered report
    Rails.application.config.spree.reports.each do |report_class|
      define_method(report_class.name.demodulize.underscore) do
        report = report_class.new(params)
        respond_to do |format|
          format.html { render_html(report) }
          format.csv { render_csv(report) }
        end
      end
    end

    private

    def render_html(report)
      metadata = report.class.metadata
      locals = {
        title: metadata[:title],
        description: metadata[:description],
        report_url: request.path,
        headers: report.headers,
        rows: report.rows,
        summary_data: {
          row_count: report.rows.count
        }.merge(metadata[:summary_data] || {})
      }.merge(report.locals)
      render report.template, locals: locals
    end

    def render_csv(report)
      headers, rows, filename = report.headers, report.rows(paginated: false), report.csv_filename
      require "csv"
      csv = CSV.generate do |csv|
        csv << headers.map(&:values).flatten unless headers.blank?
        rows.each do |row|
          csv << headers.map(&:keys).flatten.map do |key|
            value = row[key]
            value = value.join(", ").squish.gsub("&times;", "x") if value.is_a?(Array)
            value = value.prepend("'") if (key == :shipment_tracking_numbers && value.present?)
            value
          end
        end
      end
      send_data(csv, filename: filename)
    end
  end
end
