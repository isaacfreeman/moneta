ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/display'
require 'rails/test_help'
require 'spree/testing_support/factories'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


MiniTest::Display.options = {
  suite_names: true,
  color: true,
  # print: {
  #   success: "OK\n",
  #   failure: "EPIC FAIL\n",
  #   error: "ERRRRRRR\n"
  # }
}
