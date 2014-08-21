require 'chefspec'
require 'chefspec/berkshelf'
require 'spec_helper.rb'

shared_examples 'general tests' do |platform, version|
  context "on #{platform} #{version}" do

    let(:chef_run) do
      ChefSpec::Runner.new(
        platform: platform,
        version: version,
        step_into: [ 'anaconda_package' ]) do |node|
        #node.set['foo']['users'] = users
      end
    end

    it 'runs without errors. see test-kitchen tests for more comprehensive tests that are not possible here' do
      chef_run.converge(described_recipe)

      expect(chef_run).to create_directory('/opt/anaconda')
      expect(chef_run).to run_bash('run anaconda installer')
    end

    it 'generates the installer template correctly' do
      chef_run.converge(described_recipe)

      # must be exactly 4 lines
      installer_config_path = "#{Chef::Config[:file_cache_path]}/installer_config"
      expect(chef_run).to render_file(installer_config_path).with_content(/.*\n.*\n.*\n.*/)
    end

    it 'exposes the anaconda_package resource' do
      chef_run.converge('recipe[anaconda::package_tests]')

      expect(chef_run).to install_conda_package('astroid')
      expect(chef_run).to remove_conda_package('astroid')

      # for coverage
      expect(chef_run).to write_log('do NOT include this in your runlist! for testing only.')
    end

    it 'provides a convenience shell script' do
      chef_run.converge('recipe[anaconda::shell_conveniences]')

      expect(chef_run).to create_template('/etc/profile.d/anaconda-env.sh')
    end

    it 'caches the installer template' do
      chef_run.converge(described_recipe)

      installer = "Anaconda-#{chef_run.node.anaconda.version}-Linux-#{chef_run.node.anaconda.flavor}.sh"
      installer_path = "#{Chef::Config[:file_cache_path]}/#{installer}"

      expect(chef_run).to create_remote_file_if_missing(installer_path)
    end

  end
end

describe 'anaconda::default' do
  platforms = {
    # for whatever reason there's no fauxhai data for 12.10
    'ubuntu' => [ '12.04', '13.04', '13.10', '14.04' ],
    'debian' => [ '6.0.5' ],
    'centos' => [ '5.8', '6.0', '6.3' ],
    'redhat' => [ '5.8', '6.3' ],
  }

  platforms.each do |platform, versions|
    versions.each do |platform_version|
      Fauxhai.mock(platform: platform, version: platform_version)
      include_examples 'general tests', platform, platform_version
    end
  end
end
