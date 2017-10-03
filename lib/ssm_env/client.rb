class Client
  def self.get_client(region: 'us-east-1', access_key_id: , secret_access_key: )
    @ssm_client ||= AWS::SSM.Client.new(region: region, access_key_id: access_key_id, secret_access_Key: secret_access_key)
  end
end