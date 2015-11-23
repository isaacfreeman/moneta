require 'test_helper'
require 'i18n/tasks'

class I18nTest < ActiveSupport::TestCase
  setup :initialize_i18n

  test 'app has no missing keys' do
    missing_keys = @i18n.missing_keys
    assert_empty missing_keys, "Missing #{missing_keys.leaves.count} i18n keys, run `i18n-tasks missing' to show them"
  end

  test 'app has no unused keys' do
    unused_keys = @i18n.unused_keys
    assert_empty unused_keys, "#{unused_keys.leaves.count} unused i18n keys, run `i18n-tasks unused' to show them"
  end

  private

  def initialize_i18n
    @i18n = I18n::Tasks::BaseTask.new
  end
end
