# te_agent

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with te_agent](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with te_agent](#beginning-with-te_agent)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Module Description

The te_agent module installs, configures, and manages the services of the
Tripwire Enterprise Agent.

## Setup

### Setup Requirements

The Tripwire Enterprise Agent needs a Tripwire Enterprise Console server
to connect to. The server hostname and services passphrase are needed
to configure the Agent.

The Agent install files must be staged somewhere on the target system. This can
be a network drive, or you can use a separate `file` resource to manually copy
the package files to the target system.

The MSI provider for Windows is a little more forgiving and may work with URLs
or network drive paths.

### Beginning with te_agent

At minimum, you must specify the hostname and services passphrase for the
Tripwire Enterprise Console and the source path to the agent installer.

```puppet
class { 'te_agent':
  package_source         => '/mnt/share/tripwire/te_agent.bin',
  te_server_host         => 'teconsole.example.com',
  te_services_passphrase => 'correct horse battery staple',
}
```

## Usage

All parameters for the te_agent module are contained within the main `te_agent` class, so for any function of the module, set the options you want. See the common usages below for examples.

Examples omit common parameters for brevity.

### Staging the installer

```puppet
file {'/tmp/te_agent.bin':
  ensure => file,
  mode   => '0700',
  source => 'http://files.example.com/te_agent/linux/x86_64/te_agent.bin'
}
class { 'te_agent':
  package_source => '/tmp/te_agent.bin'
}
```

### Setting Custom Tags

```puppet
class { 'te_agent':
  ...
  tags => {
    'tagset_1' => 'tag1',
    'tagset_2' => ['tag2a', 'tag2b'],
  },
}
```

### Setting custom agent.properties

```puppet
class { 'te_agent':
  ...
  agent_properties => {
    'tw.launcher.debug'  => 'true',
    'tw.rmi.socketDebug' => 'true',
  },
}
```

## Reference

The full reference documentation can be generated with Puppet Strings:

```
$ bundle exec rake strings:generate
```

HTML documentation will be created under the ./doc/ directory.

## Limitations

The te_agent module was tested with Puppet 4.10, though it should work on 4.9
or later (or Puppet Enterprise 2017.1 or later).

The following Operating Systems have been tested with this module:

* Red Hat 5, 6, 7
* CentOS 5, 6, 7
* Windows 7, 8.1, 10, Server 2008 R2, Server 2012 R2, Server 2016

Other versions may work if they are supported by both Puppet and the Tripwire Enterprise Agent.

## Development

See the [contribution guidelines](CONTRIBUTING.md) for more information.
