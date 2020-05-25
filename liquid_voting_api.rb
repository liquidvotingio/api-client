require 'graphql/client'
require 'graphql/client/http'

module LiquidVotingApi
  HttpAdapter = GraphQL::Client::HTTP.new(ENV['API_URL']) do
    def headers(context)
      { "Authorization": "Bearer #{ENV['API_AUTH_TOKEN']}" }
    end
  end
  Schema = GraphQL::Client.load_schema(HttpAdapter)
  Client = GraphQL::Client.new(schema: Schema, execute: HttpAdapter)
end