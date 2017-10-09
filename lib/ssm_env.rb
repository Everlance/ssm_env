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
    secret_access_key:         (secret_access_key || ENV['AWS_SECRET_ACCESS_KEY']),
    params_list:                [] )

    yield(@config) if block_given?
    @configured = true
  end

  def run(params_list:nil)
    configure unless self.configured?
    @client = Client.get_client(region:             @config.region,
                                access_key_id:      @config.access_key_id,
                                secret_access_key:  @config.secret_access_key)
    self.fetch(client: @client, params_list: (params_list || config.params_list))

  end

  def to_env
    self.ssm_params.each { |name, attribs| ENV[name.to_s] = attribs[:value] }
  end

  def to_file(path: '/etc/profile.d/ssm')
    File.open(path, 'w') do |f|
      self.ssm_parms.each { |name, attribs| f << "#{name}=#{attribs[:value]}\n"}
    end
  end
end
