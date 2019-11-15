# @summary Manages a database within InfluxDB
#
# Creates or destroys a database within InfluxDB
#
# @example
#   influxdb::database { 'my_database_name': }
#
# @param ensure  - Create or destroy database
# @param name    - (namevar) The name of the database
#
define influxdb::database (
  Enum['present','absent'] $ensure         = 'present',
  String                   $admin_password = $influxdb::admin_password,
  String                   $admin_username = $influxdb::admin_username,
) {

  influxdb_database { "influxdb_database_${name}":
    ensure         => $ensure,
    admin_password => $admin_password,
    admin_username => $admin_username,
    database       => $name,
    require        => Influxdb_auth['configure_auth'],
  }
}
