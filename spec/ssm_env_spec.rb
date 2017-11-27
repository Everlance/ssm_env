require 'spec_helper'

describe SsmEnv do
  let(:config) do
    { region: 'us-east-1',
      access_key_id: 'foo',
      secret_access_key: 'bar' }
  end
  let(:ssm_params) {
    { 'FOO' => { value: 'bar' } }
  }
  before do
    ENV['AWS_REGION'] = config[:region]
    ENV['AWS_ACCESS_KEY_ID'] = config[:access_key_id]
    ENV['AWS_SECRET_ACCESS_KEY'] = config[:secret_access_key]
  end
  it 'has a version number' do
    expect(SsmEnv::VERSION).not_to be nil
  end
  context '.fetch' do
    it 'returns the result of fetcher' do
      allow_any_instance_of(SsmEnv::Fetcher).to receive(:fetch).and_return(ssm_params)
      expect(SsmEnv.fetch(params_list: ssm_params.keys)).to match(ssm_params)
    end
  end
  context '.to_env' do
    it 'adds the provided parameters to the current environment' do
      SsmEnv.to_env(ssm_params: ssm_params)
      ssm_params.each do |key, value|
        expect(ENV[key]).to eql(value[:value])
      end
    end
  end
  context '.to_file' do
    it 'writes provided parameters to the provided file' do
      file_path = File.expand_path('./test-env')
      SsmEnv.to_file(ssm_params: ssm_params, path: file_path)
      contents = File.read(file_path)
      ssm_params.each do |key, value|
        expect(contents).to include("#{key}=#{value[:value]}")
      end
    end
  end
  context '.client' do
    let(:client) { double(:client) }
    it 'creates a client with the correct config' do
      expect(Client).to receive(:get_client).with(config).and_return(client)
      SsmEnv.client
    end
  end
  context '.config' do
    it 'returns config that matches the current environment' do
      expect(SsmEnv.config.to_h).to match(config)
    end
  end
end
