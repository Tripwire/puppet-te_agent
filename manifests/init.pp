#
# Main class. Contains all private classes.
#
# @api public
#
# @summary The te_agent class installs, configures, and manages the services of the
#   Tripwire Enterprise Agent.
#
# @example Minimum required parameters
#    class { 'te_agent':
#      package_source         => '/mnt/share/tripwire/te_agent.bin',
#      te_server_host         => 'teconsole.example.com',
#      te_services_passphrase => 'correct horse battery staple',
#    }
#
# @example Custom tag sets
#    class { 'te_agent':
#      ...
#      tags => {
#        'tagset_1' => 'tag1',
#        'tagset_2' => ['tag2a', 'tag2b'],
#      },
#    }
#
# @param package_manage Whether to manage the TE Agent package. Default: `true`
# @param package_ensure Whether to install the TE Agent package. Default: `installed`
# @param package_install_path Path to install the TE Agent package.
#   Default: `/usr/local/tripwire/te/agent` or `C:\Program Files\Tripwire\TE\Agent`, depending on OS
# @param package_source The path to te_agent.bin or te_agent.msi. Must be a path on the local filesystem for te_agent.bin. **Required**.
# @param package_name The name of the TE Agent package. Default: varies by operating system
# @param package_provider Which package provider to use to manage the TE Agent package. Default: varies by operating system
# @param te_server_host The hostname or IP address of the TE Console. **Required**.
# @param te_services_port The TE Console services port. Default: `9898`
# @param te_services_passphrase The TE Console services passphrase. **Required**.
# @param te_server_http_port The TE Console HTTP port. Default: `8080`
# @param local_port The port the Agent will listen on for communications from the TE Console. Default: `9898`
# @param install_rtm Whether to install the Event Generator service. Default: `true`
# @param proxy_host The hostname or IP address of a TE proxy. Optional.
# @param proxy_port The port to communicate with the TE proxy. Default: `1080`
# @param rtm_port The port for the Event Generator service to communicate with the Agent. Default: `1169`
# @param enable_fips Enables FIPS mode for the Agent. Default: `false`
# @param agent_properties Additional properties to set in the Agent configuration. See documentation
#   or contact support for details on which properties are available. Note that this will only
#   ever set properties. They will not be removed from the configuration if they are removed from this parameter. Default: `undef`
# @param tags Tags to automatically apply to the node when registered.
#  Format is a Hash of tag set names to tag values, or an array of tag values. Optional.
# @param service_enable Whether to enable the TE Agent service to start at boot. Default: `true`
# @param service_ensure Whether the TE Agent service should be running. Default: `running`
# @param service_manage Whether to manage the TE Agent service. Default: `true`
# @param service_name The TE Agent service name to manage. Default value: varies by operating system
# @param service_provider Which service provider to use for the TE Agent service. Default: `undef`.
# @param service_rtm_enable Whether to enable the Event Generator service to start at boot. Default: `true`
# @param service_rtm_ensure Whether the Event Generator service should be running. Default: `running`
# @param service_rtm_manage Whether to manage the Event Generator service. Should only be used if `install_rtm` is `true`. Default: `true`
# @param service_rtm_name The Event Generator service name to manage. Default: varies by operating system
# @param service_rtm_provider Which service provider to use for the Event Generator service. Default: `undef`.
class te_agent (
  Boolean $package_manage,
  String $package_ensure,
  String $package_install_path,
  String $package_source,
  String $package_name,
  Optional[String] $package_provider,
  String $te_server_host,
  Integer[0, 65535] $te_services_port,
  String $te_services_passphrase,
  Integer[0, 65535] $te_server_http_port,
  Integer[0, 65535] $local_port,
  Boolean $install_rtm,
  Integer[0, 65535] $rtm_port,
  Optional[String] $proxy_host,
  Integer[0, 65535] $proxy_port,
  Boolean $enable_fips,
  Optional[Hash] $agent_properties,
  Optional[Hash] $tags,
  Optional[Boolean] $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  Boolean $service_manage,
  String $service_name,
  Optional[String] $service_provider,
  Boolean $service_rtm_enable,
  Enum['running', 'stopped'] $service_rtm_ensure,
  Boolean $service_rtm_manage,
  String $service_rtm_name,
  Optional[String] $service_rtm_provider,
) {

  contain te_agent::install
  contain te_agent::config
  contain te_agent::service

  Class['::te_agent::install']
  -> Class['::te_agent::config']
  ~> Class['::te_agent::service']
}
