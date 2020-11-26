require "bundler/inline"

gemfile(true) do
  source "https://rubygems.org"

  gem "mongo", '2.11.0' # 2.10.5 does not cause the segfault.
end

uri = 'mongodb+srv://root:password123@mongodb.cluster.local/admin?ssl=false'
client = Mongo::Client.new(uri)
client.database.collection_names.to_a
