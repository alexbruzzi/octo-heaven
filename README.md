# Heaven

Where god (files) reside.

# Setup

- Install God manually by using

```
$ [sudo] gem install god
```

There is no Gemfile here as for some weird issue god is unable to properly start processes with it. Refer to this [SO Question](http://stackoverflow.com/questions/36790749/unicorn-is-not-part-of-the-bundle-while-starting-from-god).

- Clone this repo
- Copy `env.example.txt` as `.env` and update the configs accordingly

# Start God

```
god -c octo.god
```

# Terminate God

```
god terminate
```

# Usage

```
  Usage:
    Starting:
      god [-c <config file>] [-p <port> | -b] [-P <file>] [-l <file>] [-D]

    Querying:
      god <command> <argument> [-p <port>]
      god <command> [-p <port>]
      god -v
      god -V (must be run as root to be accurate on Linux)

    Commands:
      start <task or group name>         start task or group
      restart <task or group name>       restart task or group
      stop <task or group name>          stop task or group
      monitor <task or group name>       monitor task or group
      unmonitor <task or group name>     unmonitor task or group
      remove <task or group name>        remove task or group from god
      load <file> [action]               load a config into a running god
      log <task name>                    show realtime log for given task
      status [task or group name]        show status
      signal <task or group name> <sig>  signal all matching tasks
      quit                               stop god
      terminate                          stop god and all tasks
      check                              run self diagnostic

    Options:
    -c, --config-file CONFIG         Configuration file
    -p, --port PORT                  Communications port (default 17165)
    -b, --auto-bind                  Auto-bind to an unused port number
    -P, --pid FILE                   Where to write the PID file
    -l, --log FILE                   Where to write the log file
    -D, --no-daemonize               Don't daemonize
    -v, --version                    Print the version number and exit
    -V                               Print extended version and build information
        --log-level LEVEL            Log level [debug|info|warn|error|fatal]
        --no-syslog                  Disable output to syslog
        --attach PID                 Quit god when the attached process dies
        --no-events                  Disable the event system
        --bleakhouse                 Enable bleakhouse profiling
```

# Configuration

- Review `.env` file. It contains the directory of all the processes. Make sure this is working and all values are legal.


# Individual Apps and App Groups

## APIHandler (API Endpoint)

This group has only one app - `api_handler`. This is the endpoint for our API.

### Start

```
god start api_handler
```

### Stop

```
god stop api_handler
```

### Restart

```
god restart api_handler
```

## APIConsumer

This group has only one app - api consumer one.

### Start

```
$ god start api_consumer
Sending 'start' command

The following watches were affected:
  api_consumer
```

### Stop

```
$ god stop api_consumer
Sending 'stop' command

The following watches were affected:
  api_consumer
```

## Resque

Takes group care of all the resque scheduler and reqsue workers. Makes sure everyone's working.

### Start

```
god -c octo.god start resque
```

### Stop

```
god -c octo.god stop resque
```

## Web Services

This group provides various web services like NewsFeed Webservice, Analytics API Webservice. Use this to turn all the webservices on.

### Start

```
god -c octo.god start webservice
```

### Stop

```
god -c octo.god stop webservice
```

## Dashboard

This group provides 2 types of dashboard services, that is, Internal Dashboard and External Dashboard. Use this to turn all the dashboards on or off.

### Start

```
god -c octo.god start dashboard
```

### Stop

```
god -c octo.god stop dashboard
```
