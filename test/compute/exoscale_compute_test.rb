require 'test_helper'

class ExoscaleComputeTest < Minitest::Test
  
  @api_key = "CC1C500-AB5E-481D-B1AF-8617176F314C" # Not a real api key
  @api_secret = "1D2A9F5-A69A-4E89-82E2-B2FA5EEDDE71" # Not a real api secret
  
  def setup
    @exo = Exoscale::Compute.new(@api_key, @api_secret)
  end
  
  def test_that_it_initializes_with_api_key
    assert_equal @exo.api_key, @api_key
  end
  
  def test_that_it_initializes_with_api_secret
    assert_equal @exo.api_secret, @api_secret
  end
  
  def test_that_it_initializes_with_api_endpoint
    assert_equal @exo.api_endpoint, ::Exoscale::COMPUTE_ENDPOINT
  end
  
end
