require 'spec_helper_acceptance'

describe 'te_agent install' do
  manifest = <<-EOS
    class { 'te_agent':
      package_source         => 'PACKAGE_SOURCE',
      te_server_host         => 'tw-testcon.example.com',
      te_services_passphrase => 'foobar',
      tags => {
        'tag_set1' => ['1_tag1', '1_tag2'],
        'tag_set2' => '2_tag1'
      },
    }
  EOS

  if host_inventory['platform'] == 'windows'
    manifest['PACKAGE_SOURCE'] = 'c:\tmp\te_agent\te_agent.msi'
    agent_dir = 'C:\Program Files\Tripwire\TE\agent'
    package_name = 'Tripwire Enterprise Agent'
    service_name = 'teagent'
    eg_service_name = 'tesvc'
  else
    manifest['PACKAGE_SOURCE'] = '/tmp/te_agent/te_agent.bin'
    agent_dir = '/usr/local/tripwire/te/agent'
    package_name = 'TWeagent'
    service_name = 'twdaemon'
    eg_service_name = 'twrtmd'
  end

  # Non-platform specific variables
  properties_file = agent_dir + '/data/config/agent.properties'
  tag_file = agent_dir + '/data/config/agent.tags.conf'

  it 'should run without errors' do
    result = apply_manifest(manifest, :catch_failures => true)
  end

  it 'should run a second time without changes' do
    result = apply_manifest(manifest, :catch_changes => true)
  end

  # Agent service installed and running
  describe service(service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  # EG service should be installed and running
  describe service(eg_service_name) do
    it { should be_enabled }
    it { should be_running }
  end

  # EG Port should be listening locally
  describe port(1169) do
    it { should be_listening }
  end

  # Verfiy Agent properties file is set correctly
  describe file(properties_file) do
    its(:content) { should match /tw\.server\.port=9898/ }
    its(:content) { should match /tw\.server\.host=tw-testcon\.example\.com/ }
    its(:content) { should match /tw\.agent\.generator\.port=1169/ }
  end

  # Verify that the tags.properties file was generated and contains the correct tags
  describe file(tag_file) do
    it { should exist }
    its(:content) { should match /tag_set1:1_tag1/ }
    its(:content) { should match /tag_set1:1_tag2/ }
    its(:content) { should match /tag_set2:2_tag1/ }
  end
end
