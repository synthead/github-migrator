class GithubIssue
  def initialize(oauth_token:, user:, repository:)
    @github = Github.new(oauth_token: oauth_token)
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

    close_issue(issue) if closed
  end

  private

  def close_issue(issue)
    @github.issues.edit(
      @user,
      @repository,
      issue.number,
      state: 'closed'
    )
  end
end
