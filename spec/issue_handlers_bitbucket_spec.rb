require 'bundler/setup'
Bundler.require(:default)

require_relative '../lib/issue_handlers/bitbucket'

# We don't want to reach out to Bitbucket while running tests, so this is a
# dummy payload that reflects real data from Bitbucket.

BITBUCKET_MOCK_ISSUE = {
  'status' => 'resolved',
  'priority' => 'major',
  'title' => 'Test issue 2',
  'reported_by' => {
    'username' => 'Synthead',
    'first_name' => 'Synthead',
    'last_name' => '',
    'display_name' => 'Synthead',
    'is_staff' => false,
    'avatar' => 'https://bitbucket.org/account/Synthead/avatar/32/?ts=1487306922',
    'resource_uri' => '/1.0/users/Synthead',
    'is_team' => false
  },
  'utc_last_updated' => '2017-02-16 08:42:42+00:00',
  'created_on' => '2017-02-16T07:10:27.191',
  'metadata' => {
    'kind' => 'bug',
    'version' => nil,
    'component' => nil,
    'milestone' => nil
  },
  'content' => 'Test issue 2 body',
  'comment_count' => 1,
  'local_id' => 2,
  'follower_count' => 1,
  'utc_created_on' => '2017-02-16 06:10:27+00:00',
  'resource_uri' => '/1.0/repositories/Synthead/github-migrator-test/issues/2',
  'is_spam' => false
}.freeze

# The read_all method fetches Butbucket issue data and serializes it for the
# GitHub API.  This payload reflects what BITBUCKET_MOCK_ISSUE should look like
# after being serialized.

GITHUB_EXPECTED_RESULT = {
  title: 'Test issue 2',
  body: 'Test issue 2 body',
  closed: true
}.freeze

# Bitbucket uses quite a few statuses.  GitHub only has open and closed
# statuses, so IssueHandlers::Bitbucket casts this via the issue_closed?
# method.  The correct casting is defined here.

BITBUCKET_OPEN_STATUSES = ['new', 'open', 'on hold'].freeze
BITBUCKET_CLOSED_STATUSES = %w(resolved invalid duplicate wontfix).freeze

describe 'IssueHandler::Bitbucket' do
  # We initialize a IssueHandlers::Bitbucket instance and actually use it
  # during tests, so we set this as nil for scope's sake.
  bitbucket = nil

  it 'can be initialized' do
    bitbucket = IssueHandlers::Bitbucket.new(
      authentication: {},
      repository: 'user/repository'
    )
  end

  it 'has a repository attribute' do
    expect(bitbucket.repository).to eq('user/repository')
  end

  it 'returns valid GitHub-formatted issues' do
    allow(bitbucket).to receive(:read_all_as_bitbucket).and_return(
      [BITBUCKET_MOCK_ISSUE]
    )

    expect(bitbucket.read_all).to eq([GITHUB_EXPECTED_RESULT])
  end

  it 'returns closed GitHub issue status on closed Bitbucket issues' do
    BITBUCKET_CLOSED_STATUSES.each do |status|
      issue = BITBUCKET_MOCK_ISSUE.merge('status' => status)
      allow(bitbucket).to receive(:read_all_as_bitbucket).and_return([issue])

      expect(bitbucket.read_all).to eq([GITHUB_EXPECTED_RESULT])
    end
  end

  it 'returns open GitHub issue status on open Bitbucket issues' do
    BITBUCKET_OPEN_STATUSES.each do |status|
      issue = BITBUCKET_MOCK_ISSUE.merge('status' => status)
      allow(bitbucket).to receive(:read_all_as_bitbucket).and_return([issue])

      expect(bitbucket.read_all).to eq(
        [GITHUB_EXPECTED_RESULT.merge(closed: false)]
      )
    end
  end
end
