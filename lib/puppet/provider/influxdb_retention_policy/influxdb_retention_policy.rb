# frozen_string_literal: true

require 'json'

Puppet::Type.type(:influxdb_retention_policy).provide(:retention_policy) do
  def influx_cli(command)
    `influx -execute "#{command}" -username "#{resource[:admin_username]}" -password "#{resource[:admin_password]}" -format json`
  end

  def find_rp
    JSON.parse(influx_cli("SHOW RETENTION POLICIES ON \"#{resource[:database]}\""))['results'][0]['series'][0]['values'].find { |i| i[0] == resource[:retention_policy] }
  end

  # OVERRIDDEN PUPPET FUNCTIONS #
  def duration
    find_rp[1]
  end

  def duration=(value)
    influx_cli("ALTER RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\" DURATION #{value}")
  end

  def shard_duration
    find_rp[2]
  end

  def shard_duration=(value)
    influx_cli("ALTER RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\" SHARD DURATION #{value}")
  end

  def replicas
    find_rp[3]
  end

  def replicas=(value)
    influx_cli("ALTER RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\" REPLICATIONS #{value}")
  end

  def is_default
    find_rp[4]
  end

  def is_default=(_value)
    influx_cli("ALTER RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\" DEFAULT")
  end

  def exists?
    !find_rp.nil?
  end

  def create
    shard_duration_cmd = resource[:shard_duration].nil? ? '' : "SHARD DURATION #{resource[:shard_duration]}"

    if resource[:is_default]
      influx_cli("CREATE RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\" DURATION #{resource[:duration]} REPLICATION #{resource[:replicas]} #{shard_duration_cmd} DEFAULT")
    else
      influx_cli("CREATE RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\" DURATION #{resource[:duration]} REPLICATION #{resource[:replicas]} #{shard_duration_cmd}")
    end
  end

  def destroy
    influx_cli("DROP RETENTION POLICY \"#{resource[:retention_policy]}\" ON \"#{resource[:database]}\"")
  end
end
