require 'vagrant'
require 'tty-prompt'
require 'yaml'

module VagrantYamlOptions
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

    def execute
      @env.ui.say(:info, "Welcome to the SamuraiWTF target selector!")
      all_targets = Dir.glob("target_install/*").map { |name| name[15..-4] }
      default_options = YAML.load_file('default-options.yaml')

      default_indices = []
      all_targets.each_with_index { |name, index|
          if default_options['targets'].index(name) != nil
              default_indices.push(index + 1)
          end
      }

      @env.ui.say(:info, default_indices)

      selected_targets = @prompt.multi_select("Select targets (space to toggle, enter when done)", echo: false) do |menu|
        menu.default(*default_indices)

        all_targets.each do |target|
          menu.choice target
        end
      end

      # choices = all_targets #default_options['targets']
      # selected_targets = @prompt.multi_select("Select your targets (enter when done)", choices)
      @env.ui.say(:info, "Chose: #{selected_targets}")
    end

  end
end
