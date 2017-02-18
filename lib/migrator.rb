class Migrator
  def initialize(source:, destination:)
    @source = source
    @destination = destination
  end

  def migrate
    fetch_issues
    migrate_fetched_issues
  end

  private

  def fetch_issues
    print "Fetching issues from #{@source.handler_name}" \
      " repository #{@source.repository}... "

    @issues = @source.read_all

    puts "#{@issues.length} issues found."
  end

  def migrate_fetched_issues
    puts "Creating #{@issues.length} issues in" \
      " #{@destination.handler_name} repository #{@destination.repository}..."

    @issues.each_with_index do |issue, index|
      @destination.create(issue)
      puts "[#{index + 1}/#{@issues.length}] #{issue[:title]}"
    end
  end
end
