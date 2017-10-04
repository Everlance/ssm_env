require 'aws-sdk'

module Fetcher

  def self.included(base)
    base.send :attr_reader, :ssm_params
    extend ClassMethods
    include InstanceMethods
  end

  module ClassMethods
    def call(client:, params_list: )
      fetcher = Fetcher.new(params_list: params_list)
      fetcher.fetch(client: client)
    end
  end

  module InstanceMethods
    def fetch(client:)
      raise ArgumentError.new("Client is incompatable type #{client.class}") unless client.is_a?(Aws::SSM::Client)
      batch_size = 10
      @params_list.each_slice(batch_size) do |params_slice|
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

  def initialize(params_list: [])
    @params_list = params_list
    @ssm_params = {}
  end

end