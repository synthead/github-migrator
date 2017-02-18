class ConfigData
  def initialize(config_path)
    @config = %w(github bitbucket).map { |k| [k, {}] }.to_h

    merge_config_yaml_with_exceptions(config_path)
    merge_options
  end

  def [](config_section)
    @config[config_section]
  end

  private

  def merge_options
    option_parser = OptionParser.new do |options|
      options.on(
        '--bitbucket-repo REPO',
        'Bitbucket repository to read issues from'
      ) do |repo|
        @config['bitbucket'][:repository] = repo
      end

      options.on(
        '--github-repo REPO',
        'GitHub repository to write issues to'
      ) do |repo|
        @config['github'][:repository] = repo
      end
    end

    option_parser.parse!(ARGV)
  end

  def merge_config_yaml(config_path)
    yaml_data = YAML.load_file(config_path)

    unless yaml_data.is_a?(Hash)
      abort("Encountered malformed data while reading \"#{path}\"!")
    end

    @config.merge!(yaml_data)
  end

  def merge_config_yaml_with_exceptions(path)
    merge_config_yaml(path)
  rescue Errno::ENOENT
    abort("\"#{path}\" does not exist!")
  rescue Errno::EACCES
    abort("No permission to read \"#{path}\"!")
  rescue Errno::EISDIR
    abort("\"#{path}\" is a directory!")
  end
end
