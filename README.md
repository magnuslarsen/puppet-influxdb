# Overview
This module will install and configure InfluxDB 1.x.

This module works on Debian- and RHEL-based OS'es.

## Dependencies
This module depends on the toml gem, which has to be installed on the puppetmaster.

It can be installed via puppet, like this ([using this module](https://forge.puppet.com/puppetlabs/puppetserver_gem)):
```puppet
package { 'toml':
  ensure   => 'installed',
  provider => 'puppetserver_gem',
}
```

# Sample setup
```puppet
class { '::influxdb':
  admin_username => <admin username>,
  admin_password => <admin password>,
  configuration  => {
    'data'  => {
      'dir'                     => '/mnt/influxdb/data',
      'wal-dir'                 => '/mnt/influxdb/wal',
      'max-series-per-database' => 0,
      'max-values-per-tag'      => 0,
    },
    '[udp]' => {
      'enabled'       => true,
      'bind-address'  => ':8090',
      'database'      => 'metrics',
      'batch-pending' => 1024,
      'read-buffer'   => 33554432,
    },
  },
}

influxdb::database { 'metrics': }

influxdb::user { 'grafana_user':
  password   => 'mySuperSecretPassWORD',
  privilege  => 'READ',
  database   => 'metrics',
}
```

# http auth
http_auth is automatically enabled and configured.

An admin account will automatically be created with the parameters passed to the main class: `influxdb::admin_username` and `influxdb::admin_password`

This admin account is the one used in puppet, to manage all resources
