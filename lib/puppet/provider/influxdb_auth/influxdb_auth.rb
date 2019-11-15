# frozen_string_literal: true

require 'json'
require 'English'

Puppet::Type.type(:influxdb_auth).provide(:auth_configure) do
  def influx_cli(command)
    `influx -execute "#{command}" -username "#{resource[:admin_username]}" -password "#{resource[:admin_password]}" -format json`
  end

  # OVERRIDDEN PUPPET FUNCTIONS #
  def exists?
    influx_cli(';')
    $CHILD_STATUS.exitstatus.zero?
  end

  def create
    # In order to create the auth config, we have to do the following:
    # 1. Make sure the service runs without auth
    # 2. (re)Create the admin user
    # 3. Reenable auth

    `cp "#{resource[:config_path]}" /tmp/influxdb.conf`
    `sed 's/^auth-enabled.*/auth-enabled = false/' -i "#{resource[:config_path]}"`
    `systemctl restart influxd`
    sleep(10) # Give influx time to restart...

    influx_cli("DROP USER \"#{resource[:admin_username]}\"")
    influx_cli("CREATE USER \"#{resource[:admin_username]}\" WITH PASSWORD '#{resource[:admin_password]}' WITH ALL PRIVILEGES")

    `mv --force /tmp/influxdb.conf "#{resource[:config_path]}"`
    `systemctl restart influxd`
  end

  def destroy
    notice("Can't destroy config auth!")
  end
end
