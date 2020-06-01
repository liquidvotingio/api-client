require_relative 'spec_helper'

# Loading LiquidVotingApi::Client will send a http request for the api's graphql schema,
# since GraphQL::Client has to be assigned to a constant for performance reasons.
# We wrap the whole describe block and require the file within it  as to record the schema request.
VCR.use_cassette('fetch_schema') do
  require_relative '../liquid_voting_api'
end
describe LiquidVotingApi::Client do
  describe "#create_vote" do
    let(:alice_email) { "alice@test.com" }

    it "returns created vote with yes, weight, participant email and voting results" do
      VCR.use_cassette('create_vote') do
        vote = described_class.create_vote(yes: true, proposal_url: "http://proposals.com/1", voter_email: alice_email)
        expect(vote.yes).to eql true
        expect(vote.weight).to eql 1
        expect(vote.participant.email).to eql alice_email
        expect(vote.voting_result.no).to eql 0
        expect(vote.voting_result.yes).to eql 1
      end
    end
  end

  describe "#create_delegation" do
    let(:alice_email) { "alice@test.com" }
    let(:bob_email) { "bob@test.com" }

    it "returns true" do
      VCR.use_cassette('create_delegation') do
        expect(
          described_class.create_delegation(proposal_url: "http://proposals.com/1", delegator_email: bob_email, delegate_email: alice_email)
        ).to eql true
      end
    end
  end

  describe "#delete_delegation for a proposal" do
    let(:alice_email) { "alice@test.com" }
    let(:bob_email) { "bob@test.com" }

    it "returns updated result" do
      VCR.use_cassette('delete_delegation') do
        deleted_delegation = described_class.delete_delegation(proposal_url: "http://proposals.com/1", delegator_email: bob_email, delegate_email: alice_email)
        expect(deleted_delegation.voting_result.no).to eql 0
        expect(deleted_delegation.voting_result.yes).to eql 0
      end
    end
  end
end