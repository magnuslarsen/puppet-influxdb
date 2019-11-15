# frozen_string_literal: true

Puppet::Type.newtype(:influxdb_user) do
  @doc = 'Create or update a user in InfluxDB.'

  feature :user_management, 'require rest api', methods: [:user_management]

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

  newparam(:username) do
    desc 'The user to create'
  end

  newparam(:password) do
    desc 'Password for the user to create'
  end

  newparam(:is_admin) do
    desc 'Whether to user is a admin or normal user'
  end

  newparam(:database) do
    desc 'Which database to grant access to'
  end

  newproperty(:privilege) do
    desc 'Which privilege to use'

    def insync?(is)
      is == should
    end
  end
end
