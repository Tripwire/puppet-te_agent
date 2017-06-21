# Installs the TE Agent. Private class.
# @api private
class te_agent::install inherits te_agent {

  if $te_agent::package_manage {
    $install_options = $facts['kernel'] ? {
      windows => ['/qn', te_agent::msi_install_args()],
      default => ['--silent', te_agent::agent_bin_args()],
    }
    package { 'Tripwire Enterprise Agent':
      ensure          => $te_agent::package_ensure,
      source          => $te_agent::package_source,
      name            => $te_agent::package_name,
      provider        => $te_agent::package_provider,
      install_options => $install_options,
    }
  }
}
