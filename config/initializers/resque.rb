if ENV['RAILS_ENV'] == "development"
    Resque.redis = Redis.new #localhost redis server
else
    Resque.redis = REDIS # redistogo as configured in initializers/resque.rb
end

Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }