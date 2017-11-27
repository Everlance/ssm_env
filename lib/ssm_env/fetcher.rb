require 'aws-sdk'

module SsmEnv
  class Fetcher
    attr_accessor :ssm_params
    attr_reader :client

    def initialize(client: )
      @client = client
    end

    def fetch(params: )
      batch_size, self.ssm_params = 10, {}

      params.each_slice(batch_size) do |params_slice|
        response = self.client.get_parameters(names: params_slice, with_decryption: true)
        # Transforms to { :name => { value: value, type: type } }
        response_params = Hash[response.parameters.map { |item| [item.name.to_sym, {value: item.value, type: item.type}] }]
        response_params.each do |name, attributes|
          self.ssm_params[name] ||= {}
          self.ssm_params[name][:value] = attributes[:value]
          self.ssm_params[name][:type] = attributes[:type]
        end
      end
      self.ssm_params
    end
  end
end
