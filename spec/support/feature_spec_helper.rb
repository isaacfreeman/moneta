require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara::Screenshot.prune_strategy = :keep_last_run
