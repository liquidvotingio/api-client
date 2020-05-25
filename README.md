# liquidvoting.io ruby-client

Ruby GraphQL client for liquidvoting.io

```ruby
LiquidVoting::Client.create_vote(yes: true, proposal_url: "https://my.decidim.com/proposal", voter_email: "alice@email.com")
=> vote
vote.yes => true
vote.voting_result.yes => 1
vote.voting_result.no => 0
```
