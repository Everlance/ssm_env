$: << File.expand_path('./lib/ssm_env')
require 'ostruct'
require "ssm_env/version"
require "ssm_env/fetcher"
require "ssm_env/client"

module SsmEnv
  def self.fetch(params_list: , access_key_id: nil, secret_access_key: nil)
    @fetcher ||= SsmEnv::Fetcher.new(client: SsmEnv.client(access_key_id, secret_access_key))
    @ssm_params = @fetcher.fetch(params: params_list)
  end
  def self.to_env(ssm_params: )
    ssm_params.each { |name, attribs| ENV[name.to_s] = attribs[:value] }
  end
  def self.to_file(ssm_params: ,path: '/etc/profile.d/ssm')
    File.open(path, 'w') do |f|
      ssm_params.each { |name, attribs| f << "#{name}=#{attribs[:value]}\n"}
    end
  end
  def self.client(access_key_id, secret_access_key)
    @client = Client.get_client(region:             SsmEnv.config.region,
                                access_key_id:      access_key_id || SsmEnv.config.access_key_id,
                                secret_access_key:  secret_access_key || SsmEnv.config.secret_access_key)
  end
  def self.config
    @config ||= OpenStruct.new(
        region:         (ENV['AWS_REGION'] || 'us-east-1'),
        access_key_id:        ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key:         ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
