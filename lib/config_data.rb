class ConfigData
  attr_accessor :config

  def initialize(config_dir, endpoints)
    @config = load_config_files(config_dir, endpoints)
  end

  private

  def load_config_files(config_dir, endpoints)
    {}.tap do |config|
      endpoints.each do |endpoint|
        path = File.join(config_dir, "#{endpoint}.yml")
        config[endpoint] = load_yaml_with_exceptions(path)
      end
    end
  end

  def load_valid_yaml(path)
    yaml_data = YAML.load_file(path)

    unless yaml_data.is_a?(Hash)
      abort("Encountered malformed data while reading \"#{path}\"!")
    end

    yaml_data
  end

  def load_yaml_with_exceptions(path)
    load_valid_yaml(path)
  rescue Errno::ENOENT
    abort("\"#{path}\" does not exist!")
  rescue Errno::EACCES
    abort("No permission to read \"#{path}\"!")
  rescue Errno::EISDIR
    abort("\"#{path}\" is a directory!")
  end
end
