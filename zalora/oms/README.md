# Requirements

Download package JDK-12.0.2 and extracts following locations `php*/fpm/extions/jdk-12.0.2`

# Setup

## Init rabbitmq

Create oms queues
```
$ zoms run external/rabbitmq/setup
```

Start oms consumers
```
$ zoms run daemon/daemon-watchdog/start-daemons
```

Stop oms consumers
```
$ zoms run daemon/daemon-watchdog/stop-daemons
```
