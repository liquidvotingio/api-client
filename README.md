# liquidvoting.io ruby-client

[![Actions Status](https://github.com/liquidvotingio/ruby-client/workflows/CI/CD/badge.svg)](https://github.com/liquidvotingio/ruby-client/actions?query=workflow%3ACI%2FCD)

Ruby GraphQL client for liquidvoting.io

```ruby
# Demo auth key for live api. Demo data gets wiped out from time to time
ENV['LIQUID_VOTING_API_AUTH_KEY'] = '62309201-d2f0-407f-875b-9f836f94f2ca'
ENV['LIQUID_VOTING_API_URL'] = 'https://api.liquidvoting.io'

require_relative 'liquid_voting_api'

alice_email = "alice@email.com"
bob_email = "bob@email.com"
proposal_url = "https://my.decidim.com/proposal"

LiquidVotingApi::Client.create_delegation(
  proposal_url: proposal_url,
  delegate_email: alice_email,
  delegator_email: bob_email
)
=> true

LiquidVotingApi::Client.create_vote(
  yes: true,
  proposal_url: proposal_url,
  voter_email: alice_email
)
=> vote
vote.yes => true
vote.weight => 2
vote.participant.email => "alice@email.com"
vote.voting_result.yes => 2
vote.voting_result.no => 0

LiquidVotingApi::Client.delete_vote(
  proposal_url: proposal_url,
  voter_email: alice_email
)
=> deleted_vote
deleted_vote.participant.email => "alice@email.com"
deleted_vote.voting_result.yes => 0
deleted_vote.voting_result.no => 0

LiquidVotingApi::Client.delete_delegation(
  proposal_url: proposal_url,
  delegate_email: alice_email,
  delegator_email: bob_email
)
=> deleted_delegation
deleted_delegation.voting_result.yes => 0
deleted_delegation.voting_result.no => 0

```
