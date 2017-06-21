# Configures the Agent Tag file. Private class.
# @api private
class te_agent::config inherits te_agent {

  # "purged" will remove all configuration files
  if $te_agent::package_ensure != 'purged' {
    $tags = $te_agent::tags
    if $tags {
      file { 'agent.tags.conf':
        ensure  => file,
        path    => "${te_agent::package_install_path}/data/config/agent.tags.conf",
        content => template('te_agent/agent.tags.conf.erb'),
      }
    }

    $agent_properties = [
      "set webserver.http.port ${te_agent::te_server_http_port}",
      "set tw.server.host ${te_agent::te_server_host}",
      "set tw.server.port ${te_agent::te_services_port}",
      "set tw.agent.generator.port ${te_agent::rtm_port}",
      "set tw.local.port ${te_agent::local_port}",
    ]
    $proxy_properties = $te_agent::proxy_host ? {
      undef => [],
      default => [
        "set tw.proxy.host ${te_agent::proxy_host}",
        "set tw.proxy.port ${te_agent::proxy_port}",
      ]
    }
    $custom_properties = $te_agent::agent_properties ? {
      undef => [],
      default => $te_agent::agent_properties.reduce([]) |$memo, $value| { $memo + ["set ${value[0]} ${value[1]}"] }
    }
    augeas { 'agent.properties':
      incl    => "${te_agent::package_install_path}/data/config/agent.properties",
      lens    => 'Properties.lns',
      changes => $agent_properties + $proxy_properties + $custom_properties,
    }
  }
}
