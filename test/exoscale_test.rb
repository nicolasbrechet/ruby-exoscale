require 'test_helper'

class ExoscaleTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Exoscale::VERSION
  end
end
