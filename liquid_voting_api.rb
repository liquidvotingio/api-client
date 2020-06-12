require 'rubygems'
require 'bundler/setup'

require 'graphql/client'
require 'graphql/client/http'

module LiquidVotingApi
  module Client
    URL = ENV.fetch('LIQUID_VOTING_API_URL', 'https://api.liquidvoting.io')
    AUTH_KEY = ENV.fetch('LIQUID_VOTING_API_AUTH_KEY', '62309201-d2f0-407f-875b-9f836f94f2ca')

    HTTP = GraphQL::Client::HTTP.new(URL) do
      def headers(context)
        { "Authorization": "Bearer #{AUTH_KEY}" }
      end
    end

    SCHEMA = GraphQL::Client.load_schema(HTTP)
    CLIENT = GraphQL::Client.new(schema: SCHEMA, execute: HTTP)

    CreateVoteMutation = CLIENT.parse <<-GRAPHQL
      mutation($voter_email: String, $proposal_url: String!, $yes: Boolean!) {
        createVote(participantEmail: $voter_email, proposalUrl: $proposal_url, yes: $yes) {
          yes
          weight
          participant {
            email
          }
          votingResult {
            in_favor
            against
          }
        }
      }
    GRAPHQL

    ## Example:
    ##
    ## create_vote(yes: true, proposal_url: "https://my.decidim.com/proposal", voter_email: "alice@email.com")
    ## => vote
    ## vote.yes => true
    ## vote.voting_result.in_favor => 1
    ## vote.voting_result.against => 0
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

    DeleteVoteMutation = CLIENT.parse <<-GRAPHQL
      mutation($voter_email: String, $proposal_url: String!) {
        deleteVote(participantEmail: $voter_email, proposalUrl: $proposal_url) {
          participant {
            email
          }
          votingResult {
            in_favor
            against
          }
        }
      }
    GRAPHQL

    def self.delete_vote(proposal_url:, voter_email:)
      variables = { proposal_url: proposal_url, voter_email: voter_email}
      response = CLIENT.query(DeleteVoteMutation, variables: variables)

      if response.errors.any?
        raise response.errors[:data].join(", ")
      else
        response.data.delete_vote
      end
   end

    CreateDelegationMutation = CLIENT.parse <<-GRAPHQL
      mutation($proposal_url: String!, $delegator_email: String!, $delegate_email: String!) {
        createDelegation(proposalUrl: $proposal_url, delegatorEmail: $delegator_email, delegateEmail: $delegate_email) {
          id
        }
      }

    GRAPHQL

    ## Example:
    ##
    ## create_delegation(proposal_url: "https://my.decidim.com/proposal", delegator_email: "bob@email.com", delegate_email: "alice@email.com")
    ## => true
    ##
    ## On failure it will raise an exception with the errors returned by the API
    def self.create_delegation(proposal_url:, delegator_email:, delegate_email:)
      variables = { proposal_url: proposal_url, delegator_email: delegator_email, delegate_email: delegate_email }
      response = CLIENT.query(CreateDelegationMutation, variables: variables)

      if response.errors.any?
        raise response.errors[:data].join(", ")
      else
        true
      end
    end

    DeleteDelegationMutation = CLIENT.parse <<-GRAPHQL
      mutation($proposal_url: String!, $delegator_email: String!, $delegate_email: String!) {
        deleteDelegation(proposalUrl: $proposal_url, delegatorEmail: $delegator_email, delegateEmail: $delegate_email) {
          votingResult {
            in_favor
            against
          }
        }
      }

    GRAPHQL

    ## Example:
    ##
    ## delete_delegation(proposal_url: "https://my.decidim.com/proposal", delegator_email: "bob@email.com", delegate_email: "alice@email.com")
    ## => deleted_delegation
    ## deleted_delegation.voting_result.in_favor => 0
    ## deleted_delegation.voting_result.against => 0
    ##
    ## On failure it will raise an exception with the errors returned by the API
    def self.delete_delegation(proposal_url:, delegator_email:, delegate_email:)
      variables = { proposal_url: proposal_url, delegator_email: delegator_email, delegate_email: delegate_email }
      response = CLIENT.query(DeleteDelegationMutation, variables: variables)

      if response.errors.any?
        raise response.errors[:data].join(", ")
      else
        response.data.delete_delegation
      end
    end
  end
end