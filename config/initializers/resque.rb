if ENV['RAILS_ENV'] == 'production'
  Resque.redis = REDIS # redistogo as configured in initializers/redis.rb
else
  Resque.redis = Redis.new # localhost redis server
end

Resque.after_fork = proc { ActiveRecord::Base.establish_connection }
