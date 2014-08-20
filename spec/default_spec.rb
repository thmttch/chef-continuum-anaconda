require 'chefspec'
require 'chefspec/berkshelf'
require 'spec_helper.rb'

shared_examples 'general tests' do |platform, platform_version|
  context "on #{platform} #{platform_version}" do

    let(:chef_run) do
      ChefSpec::Runner.new(
        platform: platform,
        # TODO get this working; that is, figure out how to stub this properly
        #version: platform_version,
        #step_into: [ 'anaconda_package' ]) do |node|
        version: platform_version) do |node|
        #node.set['foo']['users'] = users
      end
    end

    before do
      # TODO doesn't work
      #stub_command('/opt/anaconda/2.0.1/bin/conda install astroid --yes').and_return(true)
      #stub_command('/opt/anaconda/2.0.1/bin/conda remove astroid --yes').and_return(true)

      stub_command("rpm -qa | grep -q '^runit'").and_return(true)
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

    it 'has the anaconda_package resource' do
      chef_run.converge('recipe[anaconda::package_tests]')

      package_name = 'astroid'

      expect(chef_run).to install_anaconda_package(package_name)
      # TODO we want this test, but needs to be stubbed
      #expect(chef_run).to run_execute("conda_package_install_#{package_name}").with(
        #command: '/opt/anaconda/2.0.1/bin/conda install astroid --yes'
      #)

      expect(chef_run).to remove_anaconda_package(package_name)
      # TODO we want this test, but needs to be stubbed
      #expect(chef_run).to run_execute("conda_package_remove_#{package_name}").with(
        #command: '/opt/anaconda/2.0.1/bin/conda remove astroid --yes'
      #)

      # for coverage
      expect(chef_run).to write_log('do NOT include this in your runlist! for testing only.')
    end

    it 'has the anaconda_nbservice resource' do
      chef_run.converge('recipe[anaconda::notebook_server]')

      expect(chef_run).to create_anaconda_nbservice('notebook-server')
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
