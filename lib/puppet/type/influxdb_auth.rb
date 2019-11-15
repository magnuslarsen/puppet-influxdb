Puppet::Type.newtype(:influxdb_auth) do
  @doc = 'Setup http_auth in InfluxDB.'

  feature :auth_configure, 'require rest api', methods: [:auth_configure]

  ensurable

  newparam(:name, namevar: true) do
    desc 'A unique name for the resource'
  end

  newparam(:admin_username) do
    desc 'Admin username to manage the resource with'
  end

  newparam(:admin_password) do
    desc 'Admin password to manage the resource with'
  end

  newparam(:config_path) do
    desc 'Path to the main config file'
  end
end
