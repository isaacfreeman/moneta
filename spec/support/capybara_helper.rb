# Requirements specific to Capybara specs

require "capybara/rspec"
require "capybara/poltergeist"
require "capybara-screenshot"
require "capybara-screenshot/rspec"

Capybara.javascript_driver = :poltergeist
Capybara::Screenshot.prune_strategy = :keep_last_run
