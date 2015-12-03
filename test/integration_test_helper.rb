require "test_helper"
require 'minitest/rails/capybara'
require 'capybara/poltergeist'
require 'capybara-screenshot/minitest'

Capybara.javascript_driver = :poltergeist
Capybara::Screenshot.prune_strategy = :keep_last_run

module ActionDispatch
  class IntegrationTest
    include Capybara::DSL
  end
end
