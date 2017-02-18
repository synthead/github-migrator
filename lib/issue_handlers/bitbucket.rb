module IssueHandlers
  class Bitbucket
    attr_reader :repository
    attr_reader :handler_name

    CLOSED_STATUSES = %w(resolved invalid duplicate wontfix).freeze

    def initialize(authentication:, repository:)
      @bitbucket = ::BitBucket.new(authentication)
      @repository = repository
      @handler_name = 'Bitbucket'
    end

    def read_all
      read_all_as_bitbucket.map { |i| as_github_issue(i) }
    end

    private

    def read_all_as_bitbucket
      @bitbucket.issues.list_repository(*@repository.split('/'))
    rescue BitBucket::Error::Unauthorized
      raise(
        IssueHandlers::Unauthorized,
        "Could not authorize to #{@handler_name}!"
      )
    rescue BitBucket::Error::NotFound
      raise(
        IssueHandlers::NotFound,
        "#{@handler_name} repository \"#{@repository}\" not found!"
      )
    end

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
