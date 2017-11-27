$: << File.expand_path('./lib/ssm_env')
require 'ostruct'
require "ssm_env/version"
require "ssm_env/fetcher"
require "ssm_env/client"

module SsmEnv
  def self.fetch(params_list: )
    @fetcher ||= SsmEnv::Fetcher.new(client: SsmEnv.client)
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
  def self.client
    @client = Client.get_client(region:             SsmEnv.config.region,
                                access_key_id:      SsmEnv.config.access_key_id,
                                secret_access_key:  SsmEnv.config.secret_access_key)
  end
  def self.config
    @config ||= OpenStruct.new(
        region:         ENV['AWS_REGION'],
        access_key_id:        ENV['AWS_ACCESS_KEY_ID'],
        secret_access_key:         ENV['AWS_SECRET_ACCESS_KEY'])
  end
end
