module IssueHandlers
  class Bitbucket
    CLOSED_STATUSES = %w(resolved invalid duplicate wontfix).freeze

    def initialize(authentication:, user:, repository:)
      @bitbucket = ::BitBucket.new(authentication)
      @user = user
      @repository = repository
    end

    def read_all
      issues = @bitbucket.issues.list_repository(
        @user,
        @repository
      )

      issues.map { |i| as_github_issue(i) }
    end

    private

    def as_github_issue(issue)
      {
        title: issue['title'],
        body: issue['content'],
        closed: issue_closed?(issue)
      }
    end

    def issue_closed?(issue)
      CLOSED_STATUSES.include?(issue['status'])
    end
  end
end
