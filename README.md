# dev-env
Docker compose managed Dev Environment

## Usage:

```shell
./devenv.sh -h
DevEnv Root: /home/ray/edmodo/dev-env
docker-compose version 1.25.5, build unknown
devenv.sh [up | start | stop | clean | status | rerun]
    -h          print help
    up          create data folders and docker-compose up
    start       docker-compose start
    stop        docker-compose stop
    status      docker-compose ps
    clean       clean data folders
    rerun       clean and up
```

### Up

First run, will create folders

### Start

Start stopped dockers

### Stop

Stop running dockers

### Clean

Will clean all database folders

### Rerun

Will clean all database folders and run `UP` again

### Status

Show current status

## Notice

Will fail to create the `backend` network if the host is connected to a VPN.
