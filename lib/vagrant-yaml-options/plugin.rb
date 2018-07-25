require 'vagrant'

class VagrantYamlOptions::Plugin < Vagrant.plugin(2)
  name 'YAML Options'
  description <<-DESC
  This plugin adds commands to initialize options files which can
  later be used to persist configuration in subsequent "up" operations.
  DESC

  command "gen-options" do
    require_relative "gen-options"
    VagrantYamlOptions::GenerateOptions
  end

end
