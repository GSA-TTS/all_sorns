require "elasticsearch"
require 'faraday_middleware/aws_sigv4'
if Rails.env.production?
  full_url_and_port = '' # e.g. https://my-domain.region.es.amazonaws.com:443
  region = '' # e.g. us-west-1
  service = 'es'

  Elasticsearch::Model.client = Elasticsearch::Client.new(url: full_url_and_port) do |f|
    f.request :aws_sigv4,
    service: service,
    region: region,
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
  end
else
  Elasticsearch::Model.client = Elasticsearch::Client.new host: 'localhost:9256', log: true
end
