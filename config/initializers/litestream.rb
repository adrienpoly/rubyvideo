# Use this hook to configure the litestream-ruby gem.
# All configuration options will be available as environment variables, e.g.
# config.replica_bucket becomes LITESTREAM_REPLICA_BUCKET
# This allows you to configure Litestream using Rails encrypted credentials,
# or some other mechanism where the values are only avaialble at runtime.

Rails.application.configure do
  # An example of using Rails encrypted credentials to configure Litestream.
  litestream_credentials = Rails.application.credentials.litestream

  # Replica-specific bucket location.
  # This will be your bucket's URL without the `https://` prefix.
  # For example, if you used DigitalOcean Spaces, your bucket URL could look like:
  #   https://myapp.fra1.digitaloceanspaces.com
  # And so you should set your `replica_bucket` to:
  #   myapp.fra1.digitaloceanspaces.com
  # Litestream supports Azure Blog Storage, Backblaze B2, DigitalOcean Spaces,
  # Scaleway Object Storage, Google Cloud Storage, Linode Object Storage, and
  # any SFTP server.
  # In this example, we are using Rails encrypted credentials to store the URL to
  # our storage provider bucket.
  # config.litestream.replica_bucket = litestream_credentials&.replica_bucket

  # Replica-specific authentication key.
  # Litestream needs authentication credentials to access your storage provider bucket.
  # In this example, we are using Rails encrypted credentials to store the access key ID.
  config.litestream.replica_key_id = litestream_credentials&.replica_key_id

  # Replica-specific secret key.
  # Litestream needs authentication credentials to access your storage provider bucket.
  # In this example, we are using Rails encrypted credentials to store the secret access key.
  config.litestream.replica_access_key = litestream_credentials&.replica_access_key

  # this is a hack to get around the fact that litestream doesn't fully support the cloudflare r2 storage provider
  ENV["LITESTREAM_REPLICA_ENDPOINT"] = litestream_credentials&.replica_endpoint
  ENV["LITESTREAM_REPLICA_BUCKET"] = litestream_credentials&.replica_bucket
end
