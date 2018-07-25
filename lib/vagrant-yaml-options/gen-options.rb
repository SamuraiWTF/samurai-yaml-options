require 'vagrant'
module VagrantYamlOptions
  class GenerateOptions < Vagrant.plugin('2', :command)
    def self.synopsis
      'Interactively generate an options.yaml'
    end

    def initialize(argv, env)
      @argv = argv
      @env = env
      @cmd_name = 'gen-options'
    end

    def execute
      name = @env.ui.ask('What is your name?')
      @env.ui.say("Hello, #{name}!")
    end

  end
end
