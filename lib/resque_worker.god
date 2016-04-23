proj_dir = ENV['DIR_RECURRING_JOBS']

script_name = 'resque_worker'

num_workers = 2

num_workers.times do |num|
  God.watch do |w|
    w.name = "#{ script_name }-#{ num }"
    w.group = 'resque'

    w.dir = proj_dir
    w.interval = 30.seconds

    pid_file = File.join(proj_dir, 'shared', 'pids', "#{ script_name }-#{ num }" + '.pid')
    log_file = File.join(proj_dir, 'shared', 'log', "#{ script_name }-#{ num }" + '.log')

    w.start = "cd #{ proj_dir } && QUEUE=* rake resque:work"

    w.stop = "kill -s QUIT `cat #{ pid_file }`"

    w.env = { 'PIDFILE' => pid_file, 'BACKGROUND' => 'yes' }
    w.pid_file = pid_file
    w.log = log_file

    w.behavior(:clean_pid_file)

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
end


