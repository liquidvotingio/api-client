# liquidvoting.io ruby-client

Ruby GraphQL client for liquidvoting.io

```ruby
alice_email = "alice@email.com"
bob_email = "bob@email.com"
LiquidVoting::Client.create_delegation(proposal_url: "https://my.decidim.com/proposal", delegate_email: alice_email, delegator_email: bob_email)
=> true

LiquidVoting::Client.create_vote(yes: true, proposal_url: "https://my.decidim.com/proposal", voter_email: alice_email)
=> vote
vote.yes => true
vote.weight => 2
vote.participant.email => "alice@email.com"
vote.voting_result.yes => 2
vote.voting_result.no => 0
```
