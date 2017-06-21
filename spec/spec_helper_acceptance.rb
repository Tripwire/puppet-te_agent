require 'beaker-rspec'

# Install Puppet on all hosts
install_puppet_agent_on(hosts, options)

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  agent_root = ENV['TE_AGENT_install_root']
  raise 'Must set TE_AGENT_install_root' unless agent_root

  c.formatter = :documentation

  c.before :suite do
    # Install module to all hosts
    hosts.each do |host|
      install_dev_puppet_module_on(host, :source => module_root)

      # Copy agent installer to hosts
      logger.error('host platform is ' + host.platform.variant)
      if host.platform.variant == 'windows'
        on(host, 'mkdir c:\tmp\te_agent')
        scp_to(host, agent_root + '/windows/x86_64/te_agent.msi', 'c:/tmp/te_agent')
      else
        on(host, 'mkdir /tmp/te_agent')
        scp_to(host, agent_root + '/linux/x86_64/te_agent.bin', '/tmp/te_agent')
      end
    end
  end
end
