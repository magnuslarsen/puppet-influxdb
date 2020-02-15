# @summary Main class that ties the module together
#
# Manages InfluxDB
#
# @example
#     class { '::influxdb':
#       admin_username => $admin_username,
#       admin_password => $admin_password,
#     }
#
#     class { '::influxdb':
#       admin_username => $admin_username,
#       admin_password => $admin_password,
#       configuration  => {
#         'data'  => {
#           'dir'                     => '/mnt/influxdb/data',
#           'wal-dir'                 => '/mnt/influxdb/wal',
#           'max-series-per-database' => 0,
#           'max-values-per-tag'      => 0,
#         }
#       },
#       databases      => {
#         prometheus => {
#           ensure => present,
#         },
#       },
#       users => {
#         grafana => {
#           password => 'asdfghjkl!"§"!"$',
#         },
#         prometheus => {
#           password => 'asdfghjkl!"§"!"$',
#         },
#       }
#     }
#
# @param ensure         - Whether to create or destroy this resource
# @param ensure_package - Overwrite $ensure for the package only. Used if package needs to be anything but 'present' or 'absent'
# @param admin_password - The password used for the main admin account
# @param admin_username - The username used for the main admin account
# @param configuration  - The configuration to use. Default values will be provided for everything not written
# @param api_port       - The port which to connect to InfluxDB
# @param config_path    - The path to the main configuration file
# @param group          - The group used for permission on for everything
# @param owner          - The owner used for permission on for everything
# @param databases      - Create the provided databases. The hash is passed on to infludb::database
# @param users          - Create the provided users. The hash is passed on to infludb::user
#                         via create_resources()
#
class influxdb (
  String $admin_password,
  String $admin_username,

  Enum['present','absent'] $ensure         = 'present',
  Variant[String,Undef]    $ensure_package = undef,
  Hash                     $configuration  = {},
  Integer                  $api_port       = 8086,
  String                   $config_path    = '/etc/influxdb/influxdb.conf',
  String                   $group          = 'influxdb',
  String                   $owner          = 'influxdb',

  Hash[String, Hash[String, Any]] $databases = {},
  Hash[String, Hash[String, Any]] $users = {},
) {

  if ($ensure_package == undef and $ensure == 'present') {
    $_ensure_package = 'present'
  }
  elsif ($ensure_package == undef and $ensure == 'absent') {
    $_ensure_package = 'absent'
  }
  else {
    $_ensure_package = $ensure_package
  }

  contain ::influxdb::install
  contain ::influxdb::config
  contain ::influxdb::service

  Class['::influxdb::install']
  -> Class['::influxdb::config']
  -> Class['::influxdb::service']

  -> http_conn_validator { 'influxdb-conn-validator_auth' :
    host      => 'localhost',
    port      => $api_port,
    use_ssl   => false,
    test_url  => '/metrics',
    try_sleep => 5,
  }
  -> influxdb_auth { 'configure_auth':
    ensure         => $ensure,
    admin_password => $admin_password,
    admin_username => $admin_username,
    config_path    => $config_path,
  }

  create_resources('influxdb::database', $databases)
  create_resources('influxdb::user', $users)
}
