module IssueHandlers
  class Github
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

      close(issue) if closed
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
