require 'chefspec'
require 'chefspec/berkshelf'
#require 'chefspec/server'
require 'spec_helper.rb'
#require 'aws-sdk'

=begin
describe 'continuum-anaconda:default' do
  let(:log) {
    Logger.new(STDOUT).tap { |l| l.level = Logger::DEBUG }
  }

  before do
    stub_command("bash -c \"source /etc/profile && type rvm | cat | head -1 | grep -q '^rvm is a function$'\"").and_return(true)
    # on the ci server it looks like this
    stub_command("bash -c \"source /etc/profile.d/rvm.sh && type rvm | cat | head -1 | grep -q '^rvm is a function$'\"").and_return(true)

    # stub out chef-client: https://github.com/sethvargo/chefspec/issues/364
    Chef::Recipe.any_instance.stub(:include_recipe).and_call_original
    Chef::Recipe.any_instance.stub(:include_recipe).with('chef-client::delete_validation').and_return(true)
  end

  let(:chef_run) do
    ChefSpec::Runner.new
  end

  it 'configures xlate backups' do
    chef_run.converge(described_recipe)

    expect(chef_run).to create_cookbook_file('/home/distribution/backup-xlate.sh')
    # TODO we use cron.d everywhere but there's no matcher for it out of the box
    #expect(chef_run).to create_cron('backup-xlate')
  end
end
=end

shared_examples 'general tests' do |platform, version|
  context "on #{platform} #{version}" do

    #let(:users) { %w[user1 user2] }
    let(:chef_run) do
      ChefSpec::Runner.new(platform: platform, version: version) do |node|
        #node.set['foo']['users'] = users
      #end.converge('foo::default')
      end
    end
    #subject { chef_run }

    it 'runs without errors; anything else is untestable. see test-kitchen tests' do
      #default.anaconda.install_root = '/opt/anaconda'
      chef_run.converge(described_recipe)

      #should install_package 'foo'
      expect(chef_run).to include_recipe 'python::default'
      #expect(chef_run).to create_directory chef_run.node.anaconda.install_root
    end

    #it 'installs python' do
      ##should install_package 'foo'
      #expect(chef_run).to include_recipe 'python::default'
    #end

    #it "creates specified users" do
      ##users.each { |u| expect(chef_run).to create_user u }
    #end

  end
end

#describe 'foo::default' do
describe 'chef-continuum-anaconda::default' do
  platforms = {
    'ubuntu'   => [ '12.04', '13.04', '13.10' ],
    #'ubuntu'   => [ '12.04' ],

    #'debian'   => ['6.0.5'],
    #'centos'   => ['5.8', '6.0', '6.3'],
    #'redhat'   => ['5.8', '6.3'],
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      Fauxhai.mock(platform: platform, version: version)
      include_examples 'general tests', platform, version
    end
  end
end
