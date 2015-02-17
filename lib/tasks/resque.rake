# require 'resque/tasks'
# require 'resque_scheduler/tasks'

# namespace :resque do
#   task :setup do
#     require 'resque'
#     require 'resque/scheduler'
#   end
# end

require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task setup: [:environment] do
    require 'resque_scheduler'
    require 'resque/scheduler'
  end
end
