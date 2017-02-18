class ConfigData
  def initialize(config_path)
    @config = %w(github bitbucket).map { |k| [k, {}] }.to_h

    merge_config_yaml(config_path)
    merge_options
    prompt_for_missing_config
  end

  def [](config_section)
    @config[config_section]
  end

  private

  def merge_config_yaml(config_path)
    return unless File.exist?(config_path)
    yaml_data = YAML.load_file(config_path)
    @config.merge!(yaml_data) if yaml_data
  rescue Errno::EACCES
    abort("No permission to read \"#{path}\"!")
  rescue Errno::EISDIR
    abort("\"#{path}\" is a directory!")
  end

  def merge_options
    option_parser = OptionParser.new do |options|
      options.on(
        '--bitbucket-repo REPOSITORY',
        'Bitbucket repository to read issues from'
      ) do |repo|
        @config['bitbucket'][:repository] = repo
      end

      options.on(
        '--bitbucket-login LOGIN',
        'Bitbucket login'
      ) do |login|
        @bitbucket_login = login
      end

      options.on(
        '--github-repo REPOSITORY',
        'GitHub repository to write issues to'
      ) do |repo|
        @config['github'][:repository] = repo
      end

      options.on(
        '--github-username USERNAME',
        'GitHub username'
      ) do |username|
        @github_username = username
      end
    end

    option_parser.parse!(ARGV)
  end

  def user_input_echo(prompt)
    print prompt
    gets.chomp
  end

  def user_input_no_echo(prompt)
    print prompt
    input = STDIN.noecho(&:gets).chomp
    puts '<hidden>'

    input
  end

  def prompt_bitbucket_repository
    @config['bitbucket'][:repository] = user_input_echo(
      'Bitbucket repository to read issues from: '
    )
  end

  def prompt_bitbucket_credentials
    login = @bitbucket_login || user_input_echo('Bitbucket login: ')
    password = user_input_no_echo('Bitbucket password: ')

    @config['bitbucket'][:authentication] = {
      login: login,
      password: password
    }
  end

  def prompt_github_repository
    @config['github'][:repository] = user_input_echo(
      'GitHub repository to write issues to: '
    )
  end

  def prompt_github_credentials
    username = @github_username || user_input_echo('GitHub username: ')
    password = user_input_no_echo('GitHub password: ')

    @config['github'][:authentication] = {
      basic_auth: "#{username}:#{password}"
    }
  end

  def prompt_for_missing_config
    prompt_bitbucket_repository unless @config['bitbucket'].key?(:repository)
    prompt_bitbucket_credentials unless @config['bitbucket'].key?(
      :authentication
    )

    prompt_github_repository unless @config['github'].key?(:repository)
    prompt_github_credentials unless @config['github'].key?(:authentication)
  end
end
