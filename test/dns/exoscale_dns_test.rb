require 'test_helper'

class ExoscaleDnsTest < Minitest::Test

  @api_key = ENV['EXO_API_KEY']
  @api_secret = ENV['EXO_SECRET_KEY']
  
  def setup
    @exo = Exoscale::Dns.new(@api_key, @api_secret)
  end
  
  def test_that_it_initializes_with_api_key
    assert_equal @exo.api_key, @api_key
  end
  
  def test_that_it_initializes_with_api_secret
    assert_equal @exo.api_secret, @api_secret
  end
  
  def test_that_it_initializes_with_api_endpoint
    assert_equal @exo.api_endpoint, ::Exoscale::DNS_ENDPOINT
  end
  
end
