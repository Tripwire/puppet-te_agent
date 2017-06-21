
Puppet::Type.type(:augeas).provide(:file_line) do
  desc "An extremely naive implementation of augeas, for Windows.

  Only handles the 'set' command, and a simple 'key=value' file format."

  confine    :operatingsystem => :windows

  has_features :parse_commands, :need_to_run?, :execute_changes

  def parse_commands(data)
    data.collect do |line|
      line.split
    end
  end

  def need_to_run?
    path = resource[:incl].gsub('/', "\\")
    old_data = File.readlines(path)

    new_data = do_changes(old_data)

    new_data != old_data
  end

  def execute_changes
    path = resource[:incl].gsub('/', "\\")
    old_data = File.readlines(path)

    new_data = do_changes(old_data)

    File.open(path, 'w') do |f|
      new_data.each do |l|
        f.puts(l)
      end
    end

    :executed
  end

  def do_changes(old_data)
    new_data = old_data.dup()

    commands = parse_commands(resource[:changes])
    commands.each do |cmd_array|
      command = cmd_array.shift
      case command
        when "set"
          line = "#{cmd_array[0]}=#{cmd_array[1]}\n"
          rx = Regexp.new('^' + Regexp.escape(cmd_array[0]) + '\s*=')
          if new_data.select{|l| l.match(rx)}.size > 0
            new_data = new_data.collect{|l| l.match(rx) ? line : l}
          else
            new_data << line
          end
        else fail(_("Command '%{command}' is not supported") % { command: command })
      end
    end

    new_data
  end

end
