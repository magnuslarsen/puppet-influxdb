# @summary Manages the service of InfluxDB
#
# @example
#   Use main class
class influxdb::service {
  systemd::unit_file { 'influxdb.service':
    ensure  => $influxdb::ensure,
    path    => '/lib/systemd/system',
    notify  => Service['influxdb'],
    content => epp("${module_name}/influxd.service.epp", {
      config_path => $influxdb::config_path,
      owner       => $influxdb::owner,
      group       => $influxdb::group,
    }),
  }
  systemd::unit_file { 'influxd.service':
    ensure => $influxdb::ensure,
    target =>  '/lib/systemd/system/influxdb.service',
  }

  if ($influxdb::ensure == 'present') {
    service { 'influxdb':
      ensure => running,
      enable => true,
    }
  }
  else {
    service { 'influxdb':
      ensure => $influxdb::ensure,
      enable => false,
    }
  }
}
