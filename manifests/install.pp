# @summary Manages the installation of InfluxDB
#
# @example
#   Use main class
class influxdb::install {
  if $facts['os']['family'] == 'Debian' {
    $distro_id = downcase($facts['os']['distro']['id'])

    apt::source { 'influxdb':
      ensure   => $influxdb::ensure,
      location => "https://repos.influxdata.com/${distro_id}",
      release  => $facts['os']['distro']['codename'],
      repos    => 'stable',
      key      => {
        id     => '05CE15085FC09D18E99EFB22684A14CF2582E0C5',
        source => 'https://repos.influxdata.com/influxdb.key',
      },
    }

    if ($influxdb::ensure == 'present') {
      $_require = [Class['apt::update'], Apt::Source['influxdb']]
    }
    else {
      $_require = undef
    }
  }
  elsif $facts['os']['family'] == 'RedHat' {
    yumrepo { 'influxdb':
      ensure   => $influxdb::ensure,
      baseurl  => 'https://repos.influxdata.com/rhel/$releasever/$basearch/stable',
      gpgcheck => true,
      gpgkey   => 'https://repos.influxdata.com/influxdb.key',
      enabled  => true,
    }
    ~> exec { 'influxdb_yumrepo_yum_clean':
      command     => 'yum clean metadata expire-cache --disablerepo="*" --enablerepo="influxdb"',
      refreshonly => true,
      returns     => [0, 1],
      path        => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      cwd         => '/',
    }

    $_require = undef
  }
  else {
    fail('Module only supports Debian/RedHat OS!')
  }

  package { 'influxdb':
    ensure  => $influxdb::_ensure_package,
    require => $_require,
  }
}
