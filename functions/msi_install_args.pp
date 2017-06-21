# Formats install options for te_agent.msi. Private function.
# @api private
function te_agent::msi_install_args >> Hash {
  # puppet-lint complains about quoted booleans, hence the stupid "String(true)"
  # ags must be strings or we hit an error about include? not being available
  $base_args = {
    'ACCEPT_EULA' => String(true),
    'TE_SERVER_HOSTNAME' => $te_agent::te_server_host,
    'TE_SERVER_PORT' => String($te_agent::te_services_port),
    'SERVICES_PASSWORD' => $te_agent::te_services_passphrase,
    'INSTALL_RTM' => String($te_agent::install_rtm),
    'INSTALLDIR' => $te_agent::package_install_path,
    'START_AGENT' => String(false),
  }

  $proxy_arg = $te_agent::proxy_host ? {
    undef => {},
    default => { 'TE_PROXY_HOSTNAME' => $te_agent::proxy_host, 'TE_PROXY_PORT' => String($te_agent::proxy_port) },
  }

  $rtm_arg = $te_agent::install_rtm ? {
    true => { 'RTMPORT' => String($te_agent::rtm_port) },
    false => {},
  }

  $fips_arg = $te_agent::enable_fips ? {
    true => { 'INSTALL_FIPS' => String(true), 'TE_SERVER_HTTP_PORT' => String($te_agent::te_server_http_port) },
    false => {},
  }

  # Merge all the args
  [$base_args, $proxy_arg, $rtm_arg, $fips_arg].reduce({}) | $result, $args | { $result + $args }
}
