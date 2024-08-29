require 'aws-sdk-lambda'
require 'json'

class Invoker
  include ActiveModel::Model

  def call
    client = Aws::Lambda::Client.new(
              region: 'ap-northeast-1',
              # access_key_id: ENV['AWS_ACCESS_KEY_ID'],
              # secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
              # endpoint:'http://localstack:4566'
              credentials: Aws::ECSCredentials.new.credentials
            )
    response = client.invoke({function_name: 'http-test-function'})
    return JSON.parse(response.payload.read)
  end
end
