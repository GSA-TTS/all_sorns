require "elasticsearch"

Elasticsearch::Model.client = Elasticsearch::Client.new host: 'localhost:9256', log: true
