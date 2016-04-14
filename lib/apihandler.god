proj_dir = ENV['DIR_API_HANDLER']
script_path = File.join(proj_dir, 'consumer.rb')
script_name = 'api_handler'
pid_file = File.join(proj_dir, 'shared', 'pids', script_name + '.pid')
log_file = File.join(proj_dir, 'shared', 'logs', script_name + '.log')

God.watch do |w|
  w.name = script_name
  w.log = log_file
  w.dir = proj_dir
  w.env = ENV
  w.pid_file = pid_file
  w.start = "cd #{ proj_dir } && ruby consumer.rb"

  # QUIT gracefully shuts down workers
  w.stop = "kill -QUIT `cat #{ pid_file }`"

  # USR2 causes the master to re-create itself
  w.restart = "kill -USR2 `cat #{ pid_file }`"

end

