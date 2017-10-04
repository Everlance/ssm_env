$: << File.expand_path('./lib/ssm_env')
require 'ostruct'
require "ssm_env/version"
require "ssm_env/fetcher"
require "ssm_env/client"

module SsmEnv
  include Fetcher
  attr_reader :configured, :config
  alias_method :configured?, :configured

  # Configure the client using parameters or using a block provided
  def configure(region: 'us-east-1', access_key_id: nil, secret_access_key: nil)
    @config ||= OpenStruct.new(
          region:         (region || ENV['AWS_REGION']),
        access_key_id:         (access_key_id || ENV['AWS_ACCESS_KEY_ID']),
    secret_access_key:         (secret_access_key || ENV['AWS_SECRET_ACCESS_KEY']))

    yield(@config) if block_given?
    @configured = true
  end

  def run
    configure unless self.configured?
    @client = Client.get_client(region:             @config.region,
                                access_key_id:      @config.access_key_id,
                                secret_access_key:  @config.secret_access_key)
    self.fetch(client: @client)
    self.ssm_params.each { ENV[name.to_s] = value }
  end

end
