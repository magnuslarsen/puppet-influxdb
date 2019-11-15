# frozen_string_literal: true

require 'json'

Puppet::Type.type(:influxdb_database).provide(:database_management) do
  def influx_cli(command)
    `influx -execute "#{command}" -username "#{resource[:admin_username]}" -password "#{resource[:admin_password]}" -format json`
  end

  # OVERRIDDEN PUPPET FUNCTIONS #
  def exists?
    JSON.parse(influx_cli('SHOW DATABASES'))['results'][0]['series'][0]['values'].flatten.include?(resource[:database])
  end

  def create
    influx_cli("CREATE DATABASE #{resource[:database]}")
  end

  def destroy
    influx_cli("DROP DATABASE #{resource[:database]}")
  end
end
