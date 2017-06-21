# Manages the TE Agent and Event Generator services. Private class.
# @api private
class te_agent::service inherits te_agent {

  if $te_agent::service_manage {
    service { 'twdaemon':
      ensure     => $te_agent::service_ensure,
      enable     => $te_agent::service_enable,
      name       => $te_agent::service_name,
      provider   => $te_agent::service_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }

  if $te_agent::service_rtm_manage {
    service { 'twrtmd':
      ensure     => $te_agent::service_rtm_ensure,
      enable     => $te_agent::service_rtm_enable,
      name       => $te_agent::service_rtm_name,
      provider   => $te_agent::service_rtm_provider,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
