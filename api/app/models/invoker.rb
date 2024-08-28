require 'aws-sdk-core'
require 'net/http'
require 'uri'

class Invoker
  include ActiveModel::Model

  def lambda_url = 'https://up6ipl7kfhbdntz4vpu5istdaa0osdiu.lambda-url.ap-northeast-1.on.aws/'

  def call
    signer = aws_sigv4_signer
    uri = URI.parse(lambda_url)
    request = Net::HTTP::Post.new(uri)
    signed_request = signer.sign_request(
      http_method: 'POST',
      url: uri.to_s,
      headers: request.to_hash
    )
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    signed_request.headers.each { |key, value| request[key] = value }
    response = http.request(request)

    return response.body
  end

  def aws_sigv4_signer
    # if Rails.env.development? || Rails.env.test?
    #   Aws::Sigv4::Signer.new(
    #     service: 'lambda',
    #     region: 'ap-northeast-1',
    #     access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    #     secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    #   )
    # else
      Aws::Sigv4::Signer.new(
        service: 'lambda',
        region: 'ap-northeast-1',
        credentials: Aws::ECSCredentials.new(retries: 3)
      )
    # end
  end
end
