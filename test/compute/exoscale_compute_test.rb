require 'test_helper'

class ExoscaleComputeTest < Minitest::Test

  def setup
    @api_key = ENV['EXO_API_KEY']
    @api_secret = ENV['EXO_SECRET_KEY']
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
  
  def test_that_it_escapes_strings
    string_to_escape = "'`!? %"
    assert_equal @exo.escape(string_to_escape), "%27%60%21%3F%20%25"    
  end
  
  def test_that_it_generates_url
    parameter_hash = {"command" => "deployVirtualMachine"}
    generated_url = "https://api.exoscale.ch:443/compute?apiKey=#{@api_key.to_s}&command=deployVirtualMachine&response=json&signature=vQepdye4Yt9ZOPBwCuKPSt2dJjQ%3D"
    assert_equal @exo.generate_url(parameter_hash).to_s, generated_url.to_s
  end
  
  def test_that_it_executes_request
    params = {'command' => 'listAccounts'}
    assert_equal @exo.execute_request(@exo.generate_url( params ))["listaccountsresponse"]["account"].first["user"].first["secretkey"], @api_secret
  end
end
