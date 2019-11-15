Puppet::Type.newtype(:influxdb_database) do
  @doc = 'Create or update a database in InfluxDB.'

  feature :database_management, 'require rest api', methods: [:database_management]

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

  newparam(:database) do
    desc 'The database to create'
  end
end
