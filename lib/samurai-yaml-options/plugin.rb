require 'vagrant'

class SamuraiYamlOptions::Plugin < Vagrant.plugin(2)
  name 'SamuraiWTF YAML Options'
  description <<-DESC
  This plugin adds commands to initialize options files which can
  later be used to persist configuration in subsequent "up" operations.
  DESC

  command "wtf-options" do
    require_relative "wtf-options"
    VagrantYamlOptions::GenerateOptions
  end

end
