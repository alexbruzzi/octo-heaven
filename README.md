# Heaven

Where god (files) reside.

# Setup

Clone this repo

# Start God

```
god -c octo.god
```

# Terminate God

```
god terminate
```

# Configuration

- Review `.env` file. It contains the directory of all the processes. Make sure this is working and all values are legal.


# Individual Apps and App Groups

## APIConsumer

This group has only one app - api consumer one.

### Start

```
god -c octo.god start apiconsumer
```

### Stop

```
god -c octo.god stop apiconsumer
```

## APIHandler

This group has only one app - api handler.

### Start

```
god -c octo.god start apihandler
```

### Stop

```
god -c octo.god stop apihandler
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
