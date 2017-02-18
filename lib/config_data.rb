class ConfigData
  def initialize(config_path)
    @config = load_config_yaml(config_path)
  end

  def [](config_section)
    @config[config_section]
  end

  private

  def load_config_yaml(config_path)
    yaml_data = YAML.load_file(config_path)

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
