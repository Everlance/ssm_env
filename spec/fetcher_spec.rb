require 'spec_helper'

RSpec.describe SsmEnv::Fetcher do
  subject(:fetcher) { SsmEnv::Fetcher.new(client: client) }
  let(:client) { double(Aws::SSM::Client) }
  let(:client_response) { double }
  let(:response_parameters) do
    [OpenStruct.new(name: 'sample_param', type: 'String', value: 'sample_value')]
  end
  let(:params_list) do
    ['sample_param']
  end
  before do
    allow(client).to receive(:is_a?).and_return(Aws::SSM::Client)
    allow(client_response).to receive(:parameters).and_return(response_parameters)
    allow(client).to receive(:get_parameters).and_return(client_response)
  end
  context 'fetching parameters' do
    it 'queries the client for parameters' do
      expect(client).to receive(:get_parameters).with(names: params_list, with_decryption: true).and_return(client_response)
      subject.fetch(params: params_list)
    end
  end
end
