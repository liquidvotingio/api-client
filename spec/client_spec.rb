require_relative 'spec_helper'

# Loading LiquidVotingApi::Client will send a http request for the api's graphql schema,
# since GraphQL::Client has to be assigned to a constant for performance reasons.
# We wrap the whole describe block and require the file within it  as to record the schema request.
VCR.use_cassette('fetch_schema') do
  require_relative '../liquid_voting_api'
end
describe LiquidVotingApi::Client do
  describe "#create_votes" do
    let(:alice_email) { "alice@test.com" }

    it "returns created vote" do
      VCR.use_cassette('create_vote') do
        vote = described_class.create_vote(yes: true, proposal_url: "http://proposals.com/1", voter_email: alice_email)
        expect(vote.yes).to eql true
        expect(vote.voting_result.no).to eql 0
        expect(vote.voting_result.yes).to eql 1
      end
    end
  end
end