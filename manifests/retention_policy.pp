# @summary Manages a retention policy on a database, within InfluxDB
#
# Creates or destroys a retention policy on a database, within InfluxDB
#
# @example
#   influxdb::retention_policy { '1YearRetention':
#     database => 'prometheus',
#     duration => '8640h0m0s',
#   }
#
# @param ensure         - Create or destroy retention policies
# @param name           - (namevar) The name of the database
# @param duration       - The duration in which to keep metrics, in duration literals (https://docs.influxdata.com/influxdb/v1.7/query_language/spec/#durations)
# @param shard_duration - The duration in which to keep shards. Set to undef to let InfluxDB decide
# @param database       - Which database the policy should be applied too
# @param replicas       - The amount of replicas to use (should be the same as the number of nodes)
# @param is_default     - Wheter the policy is the default for the database
#
define influxdb::retention_policy (
  String                   $duration,
  String                   $database,
  Enum['present','absent'] $ensure         = 'present',
  String                   $admin_password = $influxdb::admin_password,
  String                   $admin_username = $influxdb::admin_username,
  Optional[String]         $shard_duration = undef,
  Integer                  $replicas       = 1,
  Boolean                  $is_default     = true,
) {

  influxdb_retention_policy { "influxdb_rp_${name}_${database}":
    ensure           => $ensure,
    admin_password   => $admin_password,
    admin_username   => $admin_username,
    database         => $database,
    duration         => $duration,
    shard_duration   => $shard_duration,
    is_default       => $is_default,
    retention_policy => $name,
    replicas         => $replicas,
    require          => Influxdb_auth['configure_auth'],
  }
}
