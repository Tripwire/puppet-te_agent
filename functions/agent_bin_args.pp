# Formats install options for te_agent.bin. Private function.
# @api private
function te_agent::agent_bin_args >> Hash {
  $base_args = {
    '--eula'        => 'accept',
    '--server-host' => $te_agent::te_server_host,
    '--server-port' => String($te_agent::te_services_port),
    '--passphrase'  => $te_agent::te_services_passphrase,
    '--install-rtm' => String($te_agent::install_rtm),
    '--install-dir' => $te_agent::package_install_path,
  }

  $proxy_arg = $te_agent::proxy_host ? {
    undef => {},
    default => { '--proxy-host' => $te_agent::proxy_host, '--proxy-port' => String($te_agent::proxy_port) },
  }

  $rtm_arg = $te_agent::install_rtm ? {
    true => { '--rtmport' => String($te_agent::rtm_port) },
    false => {},
  }

  $fips_arg = $te_agent::enable_fips ? {
    true => { '--enable-fips' => '', '--http-port' => String($te_agent::te_server_http_port) },
    false => {},
  }

  # Merge all the args
  [$base_args, $proxy_arg, $rtm_arg, $fips_arg].reduce({}) | $result, $args | { $result + $args }
}
