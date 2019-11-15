# @summary Manages a user within InfluxDB
#
# Create, destroy or update a user within InfluxDB
#
# @example
#   influxdb::user { 'read_only_user':
#     password  => 'mySuperSecretPassWORD',
#     privilege => 'READ',
#     database  => 'my_database',
#   }
#
#   influxdb::user { 'admin2':
#     password => 'Admin?Need?Better&Password',
#     is_admin => true,
#   }
#
# @param privilege - What privileges to give the user
# @param is_admin  - Whether the user should be created as an admin or not
# @param ensure    - Create or destroy user
# @param database  - What database the user should have $privileges too (only for non-admins)
# @param password  - The plain-text password to give the user
# @param name      - (namevar) The username of the user
#
define influxdb::user (
  Variant[Enum['READ', 'WRITE', 'ALL'],Undef] $privilege      = undef,
  Boolean                                     $is_admin       = false,
  Enum['present','absent']                    $ensure         = 'present',
  String                                      $admin_password = $influxdb::admin_password,
  String                                      $admin_username = $influxdb::admin_username,
  Variant[String,Undef]                       $database       = undef,
  Variant[String,Undef]                       $password       = undef,
) {

  if ($ensure == 'present' and $password == undef) {
    fail('Password need to be set, when creating a user')
  }

  if ($is_admin) {
    $_privilege = 'ALL'
  }
  elsif (!$is_admin and ($privilege == undef or $database == undef)) {
    fail('When creating a non-admin user, specify privileges and a database!')
  }
  else {
    $_privilege = $privilege
  }

  influxdb_user { "influxdb_user_${name}":
    ensure         => $ensure,
    admin_password => $admin_password,
    admin_username => $admin_username,
    is_admin       => $is_admin,
    database       => $database,
    username       => $name,
    password       => $password,
    privilege      => $_privilege,
    require        => Influxdb_auth['configure_auth'],
  }
}
