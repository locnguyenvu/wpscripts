# Build images

Init
```
zoms docker init <version|php74,php72>
```

Start
```
zoms docker start
```

Stop
```
zoms docker stop
```

Restart
```
zoms docker restart
```

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

# Development

## Debug with Vscode 

Requirements:

Extension: https://github.com/xdebug/vscode-php-debug

Configuration `.vscode/launch.json`

```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for XDebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/var/www/oms": "${workspaceRoot}"
            }
        },
        {
            "name": "Launch currently open script",
            "type": "php",
            "request": "launch",
            "program": "${file}",
            "cwd": "${fileDirname}",
            "port": 9000
        }
    ]
}
```
