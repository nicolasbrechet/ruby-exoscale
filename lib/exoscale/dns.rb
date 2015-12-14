require "base64"
require "cgi"
require "uri"
require "openssl"
require 'net/https'
require 'json'

module Exoscale
      
  class Dns
    attr_accessor :api_key, :api_secret, :api_endpoint, :x_dns_token
    
    @@digest  = OpenSSL::Digest.new('sha1')
    
    def initialize(api_key, api_secret)
      # Use something like: e = Exoscale::Dns.new(ENV['EXO_API_KEY'], ENV['EXO_SECRET_KEY'])
      @api_key = api_key
      @api_secret = api_secret
      @api_endpoint = DNS_ENDPOINT
      @x_dns_token = "#{@api_key}:#{@api_secret}"
    end
    
    def execute_request(method, path, data=nil, headers={})
      init_headers = {'Accept' => 'application/json', 'X-DNS-Token' => @x_dns_token }
      init_headers.merge!(headers)
      uri = URI(@api_endpoint+path)
      
      case method
      when 'get'
        request = Net::HTTP::Get.new(uri, initheader = init_headers)  
      when 'post'
        request = Net::HTTP::Post.new(uri, initheader = init_headers)
        request.body = data.to_json unless data.nil?
      when 'delete'
        request = Net::HTTP::Delete.new(uri, initheader = init_headers)
      when 'put'
        request = Net::HTTP::Put.new(uri, initheader = init_headers)
        request.body = data.to_json unless data.nil?
      end
      
      puts uri
      puts request.to_s
      response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
        http.request(request)
      }
      
      return JSON.parse(response.body)
    end
    
    def list_domains
      self.execute_request('get', "/domains")
    end
    
    def domain(domain_name)
      uri = "/domains/" + domain_name.to_s
      self.execute_request('get', uri)
    end
    
    def create_domain(domain_name)      
      params = {
        domain: {
          name: domain_name
        }
      }
      self.execute_request('post', "/domains", params, {'Content-Type' => 'application/json'})
    end
   
    def delete_domain(domain_name)
      uri = "/domains/" + domain_name.to_s
      self.execute_request('delete', uri)
    end
    
    def reset_domain_token(domain_name)
      uri = "/domains/" + domain_name.to_s + "/token"
      self.execute_request('post', uri)
    end
    
    def list_records(domain_name)
      uri = "/domains/" + domain_name.to_s + "/records"
      self.execute_request('get', uri)
    end
    
    def create_record(domain_name, record_name, record_type, record_content, record_ttl=nil, record_prio=nil)
      params = {
        record: {
          name: record_name,
          record_type: record_type,
          content: record_content
        }
      }
      if !record_ttl.nil?
        params[:record][:ttl] = record_ttl
      end
      if !record_prio.nil?
        params[:record][:prio] = record_prio
      end
      
      uri = "/domains/" + domain_name.to_s + "/records"
      self.execute_request('post', uri, params, {'Content-Type' => 'application/json'})
    end
    
    def record(domain_name, record_id)
      uri = "/domains/" + domain_name.to_s + "/records/" + record_id.to_s
      self.execute_request('get', uri)
    end
    
    def update_record(domain_name, record_id, record_name=nil, record_content=nil, record_ttl=nil, record_prio=nil)
      params = {
        record: {}
      }

      if !record_name.nil?
        params[:record][:name] = record_name
      end
      if !record_content.nil?
        params[:record][:content] = record_content
      end
      if !record_ttl.nil?
        params[:record][:ttl] = record_ttl
      end
      if !record_prio.nil?
        params[:record][:prio] = record_prio
      end
      
      if record_name.nil? && record_content.nil?
        raise "Record name and content can be both nil"
      else
        uri = "/domains/" + domain_name.to_s + "/records/" + record_id.to_s
        self.execute_request('put', uri, params, {'Content-Type' => 'application/json'})
      end
    end   
    
    def delete_record(domain_name, record_id)
      uri = "/domains/" + domain_name.to_s + "/records/" + record_id.to_s
      self.execute_request('delete', uri)
    end
  end
end
