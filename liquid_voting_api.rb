require 'rubygems'
require 'bundler/setup'

require 'graphql/client'
require 'graphql/client/http'

module LiquidVotingApi
  module Client
    # Only way to configure this would be by env vars?
    URL = "https://api.liquidvoting.io"
    HTTP = GraphQL::Client::HTTP.new(URL) do
      def headers(context)
        { "Authorization": "Bearer 62309201-d2f0-407f-875b-9f836f94f2ca" }
      end
    end

    SCHEMA = GraphQL::Client.load_schema(HTTP)
    CLIENT = GraphQL::Client.new(schema: SCHEMA, execute: HTTP)

    CreateVoteMutation = CLIENT.parse <<-GRAPHQL
      mutation($voter_email: String, $proposal_url: String!, $yes: Boolean!) {
        createVote(participantEmail: $voter_email, proposalUrl: $proposal_url, yes: $yes) {
          yes
          votingResult {
            yes
            no
          }
        }
      }
    GRAPHQL

    ## Example:
    ##
    ## create_vote(yes: true, proposal_url: "https://my.decidim.com/proposal", voter_email: "alice@email.com")
    ## => vote
    ## vote.yes => true
    ## vote.voting_result.yes => 1
    ## vote.voting_result.no => 0
    ##
    ## On failure it will raise an exception with the errors returned by the API
    def self.create_vote(yes:, proposal_url:, voter_email:)
      variables = { yes: yes, proposal_url: proposal_url, voter_email: voter_email}
      response = CLIENT.query(CreateVoteMutation, variables: variables)

      if response.errors.any?
        raise response.errors[:data].join(", ")
      else
        response.data.create_vote
      end
    end
  end
end