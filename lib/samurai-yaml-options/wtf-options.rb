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
      @env.ui.say(:info, "Welcome to the SamuraiWTF target selector!")

      default_options = YAML.load_file('default-options.yaml')

      selected_targets = get_item_selection(default_options, 'target')
      selected_tools = get_item_selection(default_options, 'tool')

      write_file = if File.exists?('options.yaml')
        @prompt.yes?('An options.yaml file exists. Overwrite it? (Y/n)')
      else
        true
      end

      if write_file
        File.write('options.yaml', { 'targets' => selected_targets, 'tools' => selected_tools }.to_yaml)
        @env.ui.say(:info, 'Options written to options.yaml')
      end

    end

  end
end
