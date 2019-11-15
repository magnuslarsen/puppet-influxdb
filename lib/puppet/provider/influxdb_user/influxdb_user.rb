# frozen_string_literal: true

require 'json'

Puppet::Type.type(:influxdb_user).provide(:user_management) do
  def influx_cli(command)
    `influx -execute "#{command}" -username "#{resource[:admin_username]}" -password "#{resource[:admin_password]}" -format json`
  end

  # OVERRIDDEN PUPPET FUNCTIONS #
  def privilege
    is_admin = JSON.parse(influx_cli('SHOW USERS'))['results'][0]['series'][0]['values'].to_h[resource[:username]]

    return 'ALL' if is_admin

    JSON.parse(influx_cli("SHOW GRANTS FOR \"#{resource[:username]}\""))['results'][0]['series'][0]['values'].to_h[resource[:database]]
  end

  def privilege=(value)
    influx_cli("DROP USER \"#{resource[:username]}\"")

    if resource[:is_admin]
      influx_cli("CREATE USER \"#{resource[:username]}\" WITH PASSWORD '#{resource[:password]}' WITH ALL PRIVILEGES")
    else
      influx_cli("CREATE USER \"#{resource[:username]}\" WITH PASSWORD '#{resource[:password]}'")
      influx_cli("GRANT #{value} ON #{resource[:database]} TO \"#{resource[:username]}\"")
    end
  end

  def exists?
    !JSON.parse(influx_cli('SHOW USERS'))['results'][0]['series'][0]['values'].to_h[resource[:username]].nil?
  end

  def create
    if resource[:is_admin]
      influx_cli("CREATE USER \"#{resource[:username]}\" WITH PASSWORD '#{resource[:password]}' WITH ALL PRIVILEGES")
    else
      influx_cli("CREATE USER \"#{resource[:username]}\" WITH PASSWORD '#{resource[:password]}'")
      influx_cli("GRANT #{resource[:privilege]} ON #{resource[:database]} TO \"#{resource[:username]}\"")
    end
  end

  def destroy
    influx_cli("DROP USER \"#{resource[:username]}\"")
  end
end
