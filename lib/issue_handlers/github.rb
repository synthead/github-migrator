module IssueHandlers
  class Github
    attr_reader :repository
    attr_reader :handler_name

    def initialize(authentication:, repository:)
      @github = ::Github.new(authentication)
      @repository = repository
      @handler_name = 'GitHub'
    end

    def create(title:, body:, closed: false)
      issue = @github.issues.create(
        *@repository.split('/'),
        title: title,
        body: body
      )

      (closed ? close(issue) : issue).body
    end

    private

    def close(issue)
      @github.issues.edit(
        *@repository.split('/'),
        issue.number,
        state: 'closed'
      )
    end
  end
end
