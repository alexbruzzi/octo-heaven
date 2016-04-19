proj_dir = ENV['DIR_RECURRING_JOBS']

script_name = 'resque_worker'

pid_file = File.join(proj_dir, 'shared', 'pids', script_name + '.pid')
log_file = File.join(proj_dir, 'shared', 'log', script_name + '.log')

num_workers = 10

God.watch do |w|
  w.name = script_name
  w.group = 'resque'

  w.dir = proj_dir
  w.interval = 30.seconds

  w.start = "cd #{ proj_dir } && COUNT=#{ num_workers } QUEUE=* rake resque:workers"

  w.log = log_file
  w.pid_file = pid_file

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 350.megabytes
      c.times = 2
    end
  end

  # determine the state on startup
  w.transition(:init, { true => :up, false => :start }) do |on|
    on.condition(:process_running) do |c|
      c.running = true
    end
  end

  # determine when process has finished starting
  w.transition([:start, :restart], :up) do |on|
    on.condition(:process_running) do |c|
      c.running = true
      c.interval = 5.seconds
    end

    # failsafe
    on.condition(:tries) do |c|
      c.times = 5
      c.transition = :start
      c.interval = 5.seconds
    end
  end

  # start if process is not running
  w.transition(:up, :start) do |on|
    on.condition(:process_running) do |c|
      c.running = false
    end
  end

end

