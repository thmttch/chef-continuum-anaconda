require 'chefspec'
require 'chefspec/berkshelf'
require 'spec_helper.rb'

shared_examples 'general tests' do |platform, version|
  context "on #{platform} #{version}" do

    let(:chef_run) do
      ChefSpec::Runner.new(platform: platform, version: version) do |node|
        #node.set['foo']['users'] = users
      end
    end

    it 'runs without errors. see test-kitchen tests for more comprehensive tests not possible here' do
      chef_run.converge(described_recipe)

      expect(chef_run).to include_recipe('python::default')
      expect(chef_run).to run_bash('run anaconda installer')
    end

    it 'generates the installer template correctly' do
      chef_run.converge(described_recipe)

      # must be exactly 4 lines
      installer_config_path = "#{Chef::Config[:file_cache_path]}/installer_config"
      expect(chef_run).to render_file(installer_config_path).with_content(/.*\n.*\n.*\n.*/)
    end

  end
end

describe 'anaconda::default' do
  platforms = {
    # for whatever reason there's no fauxhai data for 12.10
    'ubuntu' => [ '12.04', '13.04', '13.10' ],
    'debian' => [ '6.0.5' ],
    'centos' => [ '5.8', '6.0', '6.3' ],
    'redhat' => [ '5.8', '6.3' ],
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      Fauxhai.mock(platform: platform, version: version)
      include_examples 'general tests', platform, version
    end
  end
end
