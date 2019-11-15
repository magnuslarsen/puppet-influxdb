# @summary Manages the configuration of InfluxDB
#
# @example
#   Use main class
class influxdb::config {

  if ($influxdb::ensure == 'present') {
    $default_config = {
      'global' => {
        'reporting-disabled' => false,
        'bind-adress'        => '127.0.0.1:8088',
      },
      'meta' => {
        'dir'                  => '/var/lib/influxdb/meta',
        'retention-autocreate' => true,
        'logging-enabled'      => true,
      },
      'data' => {
        'dir'                                => '/var/lib/influxdb/data',
        'wal_dir'                            => '/var/lib/influxdb/wal',
        'wal-fsync-delay'                    => '0s',
        'index-version'                      => 'inmem',
        'trace-logging-enabled'              => false,
        'query-log-enabled'                  => true,
        'validate-keys'                      => false,
        'cache-max-memory-size'              => '1g',
        'cache-snapshot-memory-size'         => '25m',
        'cache-snapshot-write-cold-duration' => '10m',
        'compact-full-write-cold-duration'   => '4h',
        'max-concurrent-compactions'         => 0,
        'compact-throughput'                 => '48m',
        'compact-throughput-burst'           => '48m',
        'tsm-use-madv-willneed'              => false,
        'max-series-per-database'            => 1000000,
        'max-values-per-tag'                 => 100000,
        'max-index-log-file-size'            => '1m',
        'series-id-set-cache-size'           => 100,
      },
      'coordinator' => {
        'write-timeout'          => '10s',
        'max-concurrent-queries' => 0,
        'query-timeout'          => '0s',
        'log-queries-after'      => '0s',
        'max-select-point'       => 0,
        'max-select-series'      => 0,
        'max-select-buckets'     => 0,
      },
      'retention' => {
        'enabled'        => true,
        'check-interval' => '30m',
      },
      'shard-precreation' => {
        'enabled'        => true,
        'check-interval' => '10m',
        'advance-period' => '30m',
      },
      'monitor' => {
        'store-enabled'  => true,
        'store-database' => '_internal',
        'store-interval' => '10s',
      },
      'http' => {
        'enabled'                    => true,
        'flux-enabled'               => false,
        'bind-address'               => ":${influxdb::api_port}",
        'auth-enabled'               => true, # Overwrite the actual default. This module uses auth (as it should)
        'realm'                      => 'InfluxDB',
        'log-enabled'                => true,
        'suppress-write-log'         => false,
        'access-log-path'            => '',
        'write-tracing'              => false,
        'pprof-enabled'              => true,
        'pprof-auth-enabled'         => false,
        'debug-pprof-enabled'        => false,
        'ping-auth-enabled'          => false,
        'https-enabled'              => false,
        'https-certificate'          => '/etc/ssl/influxdb.pem',
        'https-private-key'          => '',
        'shared-secret'              => '',
        'max-row-limit'              => 0,
        'max-connection-limit'       => 0,
        'unix-socket-enabled'        => false,
        'bind-socket'                => '/var/run/influxdb.sock',
        'max-body-size'              => 25000000,
        'max-concurrent-write-limit' => 0,
        'max-enqueued-write-limit'   => 0,
        'enqueued-write-timeout'     => 0,
      },
      'logging' => {
        'format'        => 'auto',
        'level'         => 'info',
        'suppress-logo' => false,
      },
      'subscriber' => {
        'enabled'              => true,
        'http-timeout'         => '30s',
        'insecure-skip-verify' => false,
        'ca-certs'             => '',
        'write-concurrency'    => 40,
        'write-buffer-size'    => 1000,
      },
      '[udp]' => {
        'enabled'          => false,
        'bind-address'     => ':8089',
        'database'         => 'udp',
        'retention-policy' => '',
        'batch-size'       => 5000,
        'batch-pending'    => 10,
        'batch-timeout'    => '1s',
        'read-buffer'      => 0,
        'precision'        => 'nanoseconds',
      },
      'continuous_queries' => {
        'enabled'             => true,
        'log-enabled'         => true,
        'query-stats-enabled' => false,
        'run-interval'        => '1s',
      },
    }

    # Merge default with the inputted configuration (inputted wins if specified)
    $config = deep_merge($default_config, $influxdb::configuration)

    file { $influxdb::config_path:
      ensure  => 'file',
      content => template("${module_name}/influxdb.conf.erb"),
      owner   => $influxdb::owner,
      group   => $influxdb::group,
      notify  => Service['influxdb'],
    }

    # Make sure that the data dirs are the correct permissions
    file { $config['data']['dir']:
      ensure => directory,
      mode   => '0755',
      owner  => $influxdb::owner,
      group  => $influxdb::group,
    }
    file { $config['data']['wal-dir']:
      ensure => directory,
      mode   => '0755',
      owner  => $influxdb::owner,
      group  => $influxdb::group,
    }
    file { $config['meta']['dir']:
      ensure => directory,
      mode   => '0755',
      owner  => $influxdb::owner,
      group  => $influxdb::group,
    }
  }
  else { # if absent
    file { $influxdb::config_path:
      ensure  => $influxdb::ensure,
    }
  }
}
