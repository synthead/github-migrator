module IssueHandlers
  class Github
    attr_reader :repository

    def initialize(authentication:, repository:)
      @github = ::Github.new(authentication)
      @repository = repository
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
