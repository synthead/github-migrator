module IssueHandlers
  class Github
    attr_reader :user
    attr_reader :repository

    def initialize(authentication:, user:, repository:)
      @github = ::Github.new(authentication)
      @user = user
      @repository = repository
    end

    def create(title:, body:, closed: false)
      issue = @github.issues.create(
        @user,
        @repository,
        title: title,
        body: body
      )

      (closed ? close(issue) : issue).body
    end

    private

    def close(issue)
      @github.issues.edit(
        @user,
        @repository,
        issue.number,
        state: 'closed'
      )
    end
  end
end
