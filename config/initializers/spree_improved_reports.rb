  Rails.application.config.spree.add_class("reports")
  Rails.application.config.spree.reports << Spree::Reports::OutOfStockVariants
  Rails.application.config.spree.reports << Spree::Reports::MissingDataVariants
