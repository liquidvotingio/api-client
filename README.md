# liquidvoting.io ruby-client

[![Actions Status](https://github.com/liquidvotingio/ruby-client/workflows/CI/CD/badge.svg)](https://github.com/liquidvotingio/ruby-client/actions?query=workflow%3ACI%2FCD)

Ruby GraphQL client for liquidvoting.io

```ruby
alice_email = "alice@email.com"
bob_email = "bob@email.com"
proposal_url = "https://my.decidim.com/proposal"

LiquidVoting::Client.create_delegation(
  proposal_url: proposal_url,
  delegate_email: alice_email,
  delegator_email: bob_email
)
=> true

LiquidVoting::Client.create_vote(
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
```
