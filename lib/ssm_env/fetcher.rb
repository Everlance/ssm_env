require 'aws-sdk'

module Fetcher

  def self.included(base)
    base.send :attr_accessor, :ssm_params
    base.send :include, InstanceMethods
  end

  module InstanceMethods
    def fetch(client:, params_list:)
      raise ArgumentError.new("Client is incompatable type #{client.class}") unless client.is_a?(Aws::SSM::Client)
      batch_size = 10
      self.ssm_params ||= {}
      params_list.each_slice(batch_size) do |params_slice|
        response = client.get_parameters(names: params_slice, with_decryption: true)
        # Transforms to { :name => { value: value, type: type } }
        response_params = Hash[response.parameters.map { |item| [item.name.to_sym, {value: item.value, type: item.type}] }]
        response_params.each do |name, attributes|
          self.ssm_params[name] ||= {}
          self.ssm_params[name][:value] = attributes[:value]
          self.ssm_params[name][:type] = attributes[:type]
        end
      end
    end
  end

end
