# Basic example with required attributes set
class { 'te_agent':
  package_source         => '/tmp/te_agent/te_agent.bin',
  te_server_host         => 'tw-testcon.example.com',
  te_services_passphrase => 'foobar'
}
