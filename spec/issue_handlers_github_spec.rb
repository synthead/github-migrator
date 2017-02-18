require 'bundler/setup'
Bundler.require(:default)

require_relative '../lib/issue_handlers/github'

# We don't want to make any requests to GitHub for these tests, but we do want
# to make sure that everything leading up to these methods are tested.  We do
# this by overriding the create method to return static Github::ResponseWrapper
# instances for the duration of these tests.

GITHUB_BODY = 'test body'.freeze

GITHUB_RESPONSE_WRAPPER = Github::ResponseWrapper.new(
  Faraday::Response.new(body: GITHUB_BODY),
  Github::Client::Issues.new
).freeze

module Github
  class Client
    class Issues
      def create(*args)
        arguments(args, required: [:user, :repo]) do
          permit VALID_ISSUE_PARAM_NAMES
          assert_required %w(title)
        end

        GITHUB_RESPONSE_WRAPPER
      end
    end
  end
end

describe 'IssueHandler::Github' do
  # We initialize a IssueHandlers::Github instance and actually use it during
  # tests, so we set this as nil for scope's sake.
  github = nil

  it 'can be initialized' do
    github = IssueHandlers::Github.new(
      authentication: {},
      user: 'test-user',
      repository: 'test-repository'
    )
  end

  it 'returns issue data when "create" method is called' do
    expect(github.create(title: '', body: '')).to eq(GITHUB_BODY)
  end

  it 'calls "close" when "closed" keyword is true' do
    expect(github).to receive(:close).and_return(GITHUB_RESPONSE_WRAPPER)
    github.create(title: '', body: '', closed: true)
  end

  it 'does not call "close" when "closed" keyword is false' do
    expect(github).to_not receive(:close)
    github.create(title: '', body: '')
  end
end
