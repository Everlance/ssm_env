require 'spec_helper'

describe SsmEnv do
  let(:ssm_class) { Class.new() { include SsmEnv } }
  subject(:SsmEnv) { ssm_class.new }
  it 'has a version number' do
    expect(SsmEnv::VERSION).not_to be nil
  end

  context 'being configured ' do
    let(:region) { 'us-east-1' }
    let(:access_key_id) { 'foo' }
    let(:secret_access_key) { 'bar' }

    before do
      # Params also work
      subject.configure do |config|
        config.region = region
        config.access_key_id = access_key_id
        config.secret_access_key = secret_access_key
      end
    end

    it 'stores the region' do
      expect(subject.config.region).to eql(region)
    end

    it 'stores the access key id' do
      expect(subject.config.access_key_id).to eql(access_key_id)
    end

    it 'stores the secret access key' do
      expect(subject.config.secret_access_key).to eql(secret_access_key)
    end

  end

  context 'being run' do
    let(:client) { double(:client) }
    before do
      allow(subject).to receive(:fetch)
      allow(subject).to receive(:ssm_params).and_return([])
      allow(Client).to receive(:get_client).and_return(client)
    end

    it 'calls fetch' do
      expect(subject).to receive(:fetch)
      subject.run
    end
  end
end
