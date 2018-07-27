require 'vagrant'
require 'tty-prompt'
require 'yaml'

module SamuraiYamlOptions
  class GenerateOptions < Vagrant.plugin('2', :command)
    def self.synopsis
      'Interactively generate an options.yaml'
    end


    def initialize(argv, env)
      @argv = argv
      @env = env
      @prompt = TTY::Prompt.new
      @cmd_name = 'gen-options'
    end


    def get_item_selection(default_options, item_type)
      all_items = Dir.glob("#{item_type}_install/*").map { |name| name[item_type.length+9..-4] }
      default_indices = []
      all_items.each_with_index { |name, index|
          if default_options["#{item_type}s"].index(name) != nil
              default_indices.push(index + 1)
          end
      }

      @env.ui.say(:info, default_indices)

      @prompt.multi_select("Select #{item_type}s (space to toggle, enter when done)", echo: false) do |menu|
        menu.default(*default_indices)
        all_items.each do |target|
          menu.choice target
        end
      end

    end


    def execute
      @env.ui.say(:info, "Welcome to the SamuraiWTF options generator!")

      default_options = YAML.load_file('default-options.yaml')

      misc_settings = {}

      misc_settings['name'] = @prompt.ask("What would you like to call this VM? (Default: '#{default_options['settings']['name']}')", default: default_options['settings']['name']) do |q|
        q.validate(/^[a-zA-Z][a-zA-Z0-9\s]{5,47}$/, 'Invalid name. Must start with a letter, use only alphanumeric/spaces, have a length between 6 and 48.')
      end

      if @prompt.yes?("Setup the targets for training? (Y/n, default: #{default_options['settings']['targets'] ? 'Y' : 'n'} )")
        misc_settings['targets'] = true
        selected_targets = get_item_selection(default_options, 'target')
      else
        misc_settings['targets'] = false
        selected_targets = []
      end

      if @prompt.yes?("Setup the GUI and desktop environment? (Y/n, default: #{default_options['settings']['gui'] ? 'Y' : 'n'} )")
        misc_settings['gui'] = true
        selected_tools = get_item_selection(default_options, 'tool')
      else
        misc_settings['gui'] = false
        selected_tools = []
      end

      write_file = if File.exists?('options.yaml')
        @prompt.yes?('An options.yaml file exists. Overwrite it? (Y/n)')
      else
        true
      end

      if write_file
        File.write('options.yaml', { 'targets' => selected_targets, 'tools' => selected_tools, 'settings' => misc_settings }.to_yaml)
        @env.ui.say(:info, 'Options written to options.yaml')
      end

    end

  end
end
