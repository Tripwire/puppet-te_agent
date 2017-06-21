require 'puppet/provider/package'

Puppet::Type.type(:package).provide(:te_agent_bin, :parent => Puppet::Provider::Package) do
  desc "Support for managing the TE Agent package on non-Windows systems.

  This provider requires a `source` attribute when installing the package,
  which should be a path to a local file.

  The function te_agent::agent_bin_args() will format the `install_options` that this provider expects."

  has_feature :installable
  has_feature :uninstallable
  has_feature :purgeable
  has_feature :versionable
  has_feature :install_options

  def self.prefetch(packages)
    packages.each do |name, pkg|
      version = get_version(pkg)
      pkg.provider = new({:ensure => version, :name => name, :provider => :te_agent_bin}) if version
    end
  end

  def query
    version = get_version
    version ? {:ensure => version, :name => resource[:name], :provider => :te_agent_bin} : nil
  end

  def install
    if get_version
      # existing version must be uninstalled first
      self.uninstall
    end
    execute(['/bin/sh', resource[:source]] + install_options)
  end

  def uninstall
    execute([install_dir + '/bin/uninstall.sh'])
  end

  def purge
    execute([install_dir + '/bin/uninstall.sh', '--removeall', '--force'])
  end

  private

  def self.get_version(resource)
    # version string looks like "version=8.5.5.bmaster.r20170515203456-caf3a91.b666"
    # we want to return "8.5.5"
    begin
       Puppet::FileSystem.read(install_dir(resource) + '/data/version').chomp.split('=')[1].split('.')[0..2].join('.')
    rescue Errno::ENOENT
      # file not found
    end
  end

  def get_version
    self.class.get_version(resource)
  end

  def self.install_dir(resource)
    scan_options(resource[:install_options], '--install-dir').shift
  end

  def install_dir
    self.class.install_dir(resource)
  end

  def self.scan_options(options, key)
    return [] if options.nil?
    options.inject([]) do |repos, opt|
      if opt.is_a? Hash and opt[key]
        repos << opt[key]
      end
      repos
    end
  end

  def install_options
    join_options(resource[:install_options])
  end

  def join_options(options)
    return unless options

    options.collect do |val|
      case val
        when Hash
          val.keys.sort.collect do |k|
            val[k] != '' ? [k, val[k]] : k
          end
        else
          val
      end
    end.flatten
  end
end
