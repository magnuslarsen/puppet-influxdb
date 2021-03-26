# frozen_string_literal: true

Puppet::Type.newtype(:influxdb_retention_policy) do
  @doc = 'Create or update a user in InfluxDB.'

  feature :retention_policy, 'require rest api', methods: [:retention_policy]

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

  newparam(:retention_policy) do
    desc 'The retention policy to create'
  end

  newparam(:database) do
    desc 'The database the retention policy should be applied to'
  end

  newproperty(:duration) do
    desc 'The duration to keep data for'

    def insync?(is)
      is == should
    end
  end

  newproperty(:shard_duration) do
    desc 'The duration to keep shards for'

    def insync?(is)
      is == should
    end
  end

  newproperty(:replicas) do
    desc 'The amount of replicas to use'

    def insync?(is)
      is == should
    end
  end

  newproperty(:is_default) do
    desc 'Whether or not this policy is the default for the database'

    def insync?(is)
      is == should
    end
  end
end
