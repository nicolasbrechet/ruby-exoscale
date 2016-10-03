require "base64"
require "cgi"
require "uri"
require "openssl"
require 'net/https'
require 'json'

module Exoscale
      
  class Compute
    attr_accessor :api_key, :api_secret, :api_endpoint
    
    @@digest  = OpenSSL::Digest.new('sha1')
    
    def initialize(api_key, api_secret)
      # Use something like: e = Exoscale::Compute.new(ENV['EXO_API_KEY'], ENV['EXO_SECRET_KEY'])
      @api_key = api_key
      @api_secret = api_secret
      @api_endpoint = COMPUTE_ENDPOINT
    end
    
    def escape(string)
      string = CGI::escape(string)
      string = string.gsub(/\+|\ /, "%20")
      string
    end
        
    def generate_url(paramHash)
      params = {'apiKey' => @api_key, 'response' => 'json'}
      params.merge!(paramHash)
      
      param_array = []
      
      params.sort.each do |key, value|
        value = self.escape(value.to_s)
        param_array << key.to_s + '=' + value.gsub(/\+|\ /, "%20")#.gsub(' ', '%20')
      end

      data = param_array.join('&')
      
      signature = Base64.encode64(OpenSSL::HMAC.digest(@@digest,@api_secret,data.downcase)).strip
      signature = self.escape(signature)
      request_url = "#{@api_endpoint}?#{data}&signature=#{signature}"
      request_url 
    end
    
    def execute_request(url)
      uri = URI.parse( url )
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      
      request = Net::HTTP::Get.new(uri.request_uri)
      
      response = http.request(request)
      return JSON.parse(response.body)
    end
    
    #### VIRTUAL MACHINES
    def deploy_virtual_machine(service_offering_id, template_id, zone_id, paramHash = {})
      # GET /deployVirtualMachine
      # Creates and automatically starts a virtual machine based on a service offering, disk offering, and template.

      params = {'command' => 'deployVirtualMachine', 'serviceOfferingId' => service_offering_id, 'templateId' => template_id, 'zoneId' => zone_id}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def destroy_virtual_machine(id)
      # GET /destroyVirtualMachine
      # Destroys a virtual machine. Once destroyed, only the administrator can recover it.
      
      params = {'command' => 'destroyVirtualMachine', 'id' => id}
      execute_request(generate_url( params ))
    end
    
    def reboot_virtual_machine(id)
      # GET /rebootVirtualMachine
      # Reboots a virtual machine.
      
      params = {'command' => 'rebootVirtualMachine', 'id' => id}
      execute_request(generate_url( params ))
    end
    
    def start_virtual_machine(id)
      # GET /startVirtualMachine
      # Starts a virtual machine.
      
      params = {'command' => 'startVirtualMachine', 'id' => id}
      execute_request(generate_url( params ))
    end
    
    def stop_virtual_machine(id)
      # GET /stopVirtualMachine
      # Stops a virtual machine.

      params = {'command' => 'stopVirtualMachine', 'id' => id}
      execute_request(generate_url( params ))
    end
    
    def reset_password_for_virtual_machine(id)
      # GET /resetPasswordForVirtualMachine
      # Resets the password for virtual machine. 
      # The virtual machine must be in a “Stopped” state and the template 
      # must already support this feature for this command to take effect. [async]
      
      params = {'command' => 'resetPasswordForVirtualMachine', 'id' => id}
      execute_request(generate_url( params ))
    end
    
    def change_service_for_virtual_machine(id, service_offering_id)
      # GET /changeServiceForVirtualMachine
      # Changes the service offering for a virtual machine. 
      # The virtual machine must be in a “Stopped” state for this command to take effect.
      
      params = {'command' => 'changeServiceForVirtualMachine', 'id' => id, 'serviceOfferingId' => service_offering_id}
      execute_request(generate_url( params ))
    end
    
    def update_virtual_machine(id, paramHash = {})
      # GET /updateVirtualMachine
      # Updates properties of a virtual machine. 
      # The VM has to be stopped and restarted for the new properties to take effect. 
      # UpdateVirtualMachine does not first check whether the VM is stopped. 
      # Therefore, stop the VM manually before issuing this call.
      
      params = {'command' => 'updateVirtualMachine', 'id' => id}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def list_virtual_machines(paramHash = {})
      # GET /listVirtualMachines
      # List the virtual machines owned by the account
      
      params = {'command' => 'listVirtualMachines'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def get_vm_password(id)
      # GET /getVMPassword
      #Returns an encrypted password for the VM
      
      params = {'command' => 'getVMPassword', 'id' => id}
      execute_request(generate_url( params ))
    end
    
    #### SECURITY GROUPS
    def create_security_group(name, paramHash = {})
      # GET /createSecurityGroup
      # Creates a security group
      
      params = {'command' => 'createSecurityGroup', 'name' => name}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def delete_security_group(paramHash = {})
      # GET /deleteSecurityGroup
      # Deletes security group
      
      params = {'command' => 'deleteSecurityGroup'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def authorize_security_group_ingress(paramHash = {})
      # GET /authorizeSecurityGroupIngress
      # Authorizes a particular ingress rule for this security group
      
      params = {'command' => 'authorizeSecurityGroupIngress'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def revoke_security_group_ingress(id)
      # GET /revokeSecurityGroupIngress
      # Deletes a particular ingress rule for this security group
      
      params = {'command' => 'revokeSecurityGroupIngress', 'id' => id}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def authorize_security_group_egress(paramHash = {})
      # GET /authorizeSecurityGroupEgress
      # Authorizes a particular egress rule for this security group
      
      params = {'command' => 'authorizeSecurityGroupEgress'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def revoke_security_group_egress(id)
      # GET /revokeSecurityGroupEgress
      # Deletes a particular egress rule for this security group
      
      params = {'command' => 'revokeSecurityGroupEgress', 'id' => id}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def list_security_groups(paramHash = {})
      # GET /listSecurityGroups
      # Lists security groups
      
      params = {'command' => 'listSecurityGroups'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### TEMPLATES
    def list_templates(template_filter, paramHash = {})
      # GET /listTemplates
      # List all public, private, and privileged templates.
      
      params = {'command' => 'listTemplates', 'templateFilter' => template_filter}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### SSH Keypairs
    def create_ssh_key_pair(name, paramHash = {})
      # GET /createSSHKeyPair
      # Create a new keypair and returns the private key
      
      params = {'command' => 'createSSHKeyPair', 'name' => name}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def delete_ssh_key_pair(name, paramHash = {})
      # GET /deleteSSHKeyPair
      # Deletes a keypair by name
      
      params = {'command' => 'deleteSSHKeyPair', 'name' => name}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def list_ssh_key_pair(paramHash = {})
      # GET /listSSHKeyPairs
      # List registered keypairs
      
      params = {'command' => 'listSSHKeyPairs'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def register_ssh_key_pair(name, public_key, paramHash = {})
      # GET /registerSSHKeyPair
      # Register a public key in a keypair under a certain name
      
      params = {'command' => 'registerSSHKeyPair', 'name' => name, 'publicKey' => public_key}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### TAGS
    def create_tag(resource_ids, resource_type, tags, paramHash = {})
      # GET /createTags
      # Creates resource tag(s)
      
      params = {'command' => 'createTags', 'resourceIds' => resource_ids, 'resourceType' => resource_type, 'tags' => tags}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def delete_tag(resource_ids, resource_type, paramHash = {})
      # GET /deleteTags
      # Deletes resource tag(s)
      
      params = {'command' => 'deleteTags', 'resourceIds' => resource_ids, 'resourceType' => resource_type }
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def list_tags(paramHash = {})
      # GET /listTags
      # List resource tag(s)
      
      params = {'command' => 'listTags'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### ACCOUNT
    def list_accounts(paramHash = {})
      # GET /listAccounts
      # Lists accounts and provides detailed account information for listed accounts
      
      params = {'command' => 'listAccounts'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### EVENTS
    def listEvents(paramHash = {})
      # GET /listEvents
      # A command to list events
      
      params = {'command' => 'listEvents'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def listEventTypes
      # GET /listEventTypes
      # List Event Types
      
      params = {'command' => 'listEventTypes'}      
      execute_request(generate_url( params ))
    end
    
    #### JOBS    
    def query_async_job_result(job_id)
      # GET /queryAsyncJobResult
      # Retrieves the current status of asynchronous job.
      
      params = {'command' => 'queryAsyncJobResult', 'jobId' => job_id}
      execute_request(generate_url( params ))
    end
    
    def list_async_jobs(paramHash = {})
      # GET /listAsyncJobs
      # Lists all pending asynchronous jobs for the account.
      
      params = {'command' => 'listAsyncJobs'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### CLOUD
    def list_zones(paramHash = {})
      # GET /listZones
      # Lists zones

      params = {'command' => 'listZones'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def list_service_offerings(paramHash = {})
      # GET /listServiceOfferings
      # Lists all available service offerings.
      
      params = {'command' => 'listServiceOfferings'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    #### SNAPSHOTS
    
    def create_snapshot(volume_id, paramHash = {})
      # GET /createSnapshot
      # Creates a snapshot
      
      params = {'command' => 'createSnapshot', 'volumeid' => volume_id}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def list_snapshots(paramHash = {})
      # GET /listSnapshots
      # List available snapshots
      
      params = {'command' => 'listSnapshots'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
    def delete_snapshot(id)
      # GET /deleteSnapshot
      # Deletes a snapshot
      
      params = {'command' => 'listSnapshots', 'id' => id}
      
      execute_request(generate_url( params ))
      
    end
    
    def revert_snapshot(id)
      # GET /revertSnapshot
      # Reverts a snapshot
      
      params = {'command' => 'revertSnapshot', 'id' => id}
      
      execute_request(generate_url( params ))
      
    end
    
    #### VOLUMES
    
    def list_volumes(paramHash = {})
      # GET /listVolumes
      # List available volumes
      # http://cloudstack.apache.org/api/apidocs-4.4/user/listVolumes.html
      
      params = {'command' => 'listVolumes'}
      params.merge!(paramHash) unless paramHash.nil?
      
      execute_request(generate_url( params ))
    end
    
  end
end
