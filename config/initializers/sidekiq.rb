Sidekiq.configure_server do |config|
  #config.redis = { url: 'redis://redis.example.com:7372/12', namespace: 'mynamespace' }
  puts "Hola Entro aca"
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://devuser:root@localhost:5432/development')
	puts db
	ActiveRecord::Base.establish_connection(
		:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
		:host     => db.host,
		:username => db.user,
		:password => db.password,
		:database => db.path[1..-1],
		:encoding => 'utf8'
	)
	# Note that as of Rails 4.1 the `establish_connection` method requires
	# the database_url be passed in as an argument. Like this:
	# ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
end